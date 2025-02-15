unit Conv2DLayerUnit_mX4;

{Neural Network library, by Eric C. Joyce

 Model a Convolutional Layer as an array of one or more 2D filters:

  input mat(X) w, h       filter1      activation function vector f
 [ x11 x12 x13 x14 ]    [ w11 w12 ]   [ func1 func2 ]
 [ x21 x22 x23 x24 ]    [ w21 w22 ]
 [ x31 x32 x33 x34 ]    [ bias ]       auxiliary vector alpha
 [ x41 x42 x43 x44 ]                  [ param1 param2 ]
 [ x51 x52 x53 x54 ]      filter2
                      [ w11 w12 w13 ]
                      [ w21 w22 w23 ]
                      [ w31 w32 w33 ]
                      [ bias ]

 Filters needn't be arranged from smallest to largest; this is just for illustration.

 Note that this file does NOT seed the randomizer. That should be done by the parent program.}

interface

{**************************************************************************************************
 Constants  }

const
    RELU                = 0;                                        { [ 0.0, inf) }
    LEAKY_RELU          = 1;                                        { (-inf, inf) }
    ASIGMOID             = 2;                                        { ( 0.0, 1.0) }
    HYPERBOLIC_TANGENT  = 3;                                        { [-1.0, 1.0] }
    SOFTMAX             = 4;                                        { [ 0.0, 1.0] }
    SYMMETRICAL_SIGMOID = 5;                                        { (-1.0, 1.0) }
    THRESHOLD           = 6;                                        {   0.0, 1.0  }
    LINEAR              = 7;                                        { (-inf, inf) }

    LAYER_NAME_LEN      = 32;                                       { Length of a Layer 'name' string }

//{$DEFINE __CONV2D_DEBUG 1}

{**************************************************************************************************
 Typedefs  }

type
    Filter2D = record
        w: cardinal;                                                { Width of the filter }
        h: cardinal;                                                { Height of the filter }
        stride_h: cardinal;                                         { Stride by which we move the filter left to right }
        stride_v: cardinal;                                         { Stride by which we move the filter top to bottom }
        f: byte;                                                    { Function flag, in [RELU, LEAKY_RELU, ..., THRESHOLD, LINEAR] }
        alpha: double;                                              { Function parameter (not always applicable) }
        aW: array of double;                                         { Array of (w * h) weights, arranged row-major, +1 for the bias }
    end;
    Conv2DLayer = record
        inputW: cardinal;                                           { Dimensions of the input }
        inputH: cardinal;
        nodes: cardinal;                                            { Number of processing units in this layer = number of filters in this layer }
        filters: array of Filter2D;                                 { Array of 2D filters }
        layerName: array [0..LAYER_NAME_LEN - 1] of char;
        outLen: cardinal;                                           { Length of the output buffer }
        aout: array of double;
    end;

{**************************************************************************************************
 Prototypes  }

function add_Conv2DFilter(const filterw, filterh: cardinal; var layer: Conv2DLayer): cardinal;
                                                                    { Set entirety of i-th filter; w is length width * height + 1 }
procedure setW_i_Conv2D(const w: array of double; const i: cardinal; var layer: Conv2DLayer);
procedure setW_ij_Conv2D(const w: double; const i, j: cardinal; var layer: Conv2DLayer);
procedure setHorzStride_i_Conv2D(const stride, i: cardinal; var layer: Conv2DLayer);
procedure setVertStride_i_Conv2D(const stride, i: cardinal; var layer: Conv2DLayer);
                                                                    { Set activation function of i-th filter }
procedure setF_i_Conv2D(const func: byte; const i: cardinal; var layer: Conv2DLayer);
                                                                    { Set activation function auxiliary parameter of i-th filter }
procedure setA_i_Conv2D(const a: double; const i: cardinal; var layer: Conv2DLayer);
procedure setName_Conv2D(const n: array of char; var layer: Conv2DLayer);
procedure print_Conv2D(const layer: Conv2DLayer);
function outputLen_Conv2D(const layer: Conv2DLayer): cardinal;
function run_Conv2D(const xvec: array of double; var layer: Conv2DLayer): cardinal;

implementation

{**************************************************************************************************
 2D-Convolutional-Layers  }

{ Add a Filter2D to an existing Conv2DLayer.
  The new filter shall have dimensions 'filterw' by 'filterh'. }
function add_Conv2DFilter(const filterw, filterh: cardinal; var layer: Conv2DLayer): cardinal;
var
    i: cardinal;
begin
    {$ifdef __CONV2D_DEBUG}
    writeln('add_Conv2DFilter(', filterw, ', ', filterh, ')');
    {$endif}

    layer.nodes := layer.nodes + 1;
    SetLength(layer.filters, layer.nodes);

    layer.filters[layer.nodes - 1].w := filterw;                    //  Set newest filter's dimensions
    layer.filters[layer.nodes - 1].h := filterh;
    layer.filters[layer.nodes - 1].stride_h := 1;                   //  Default to stride (1, 1)
    layer.filters[layer.nodes - 1].stride_v := 1;
    layer.filters[layer.nodes - 1].f := RELU;                       //  Default to ReLU
    layer.filters[layer.nodes - 1].alpha := 1.0;                    //  Default to 1.0
                                                                    //  Allocate the filter matrix plus bias
    SetLength(layer.filters[layer.nodes - 1].W, filterw * filterh + 1);
    for i := 0 to filterw * filterh - 1 do                          //  Generate random numbers in [ -1.0, 1.0 ]
        layer.filters[layer.nodes - 1].aW[i] := RandomF() * 2.0 - 1.0;
    layer.filters[layer.nodes - 1].aW[filterw * filterh] := 0.0;      //  Defaut bias = 0.0
    layer.outLen := outputLen_Conv2D(layer);                        //  Update this layer's output buffer
    SetLength(layer.aout, layer.outLen);
    result := layer.nodes;
end;

{ Set entirety of i-th filter; w is length width * height + 1.
  Input array 'w' is expected to be ROW-MAJOR:
       filter
  [ w0  w1  w2  ]
  [ w3  w4  w5  ]
  [ w6  w7  w8  ]  [ bias (w9) ]  }
procedure setW_i_Conv2D(const w: array of double; const i: cardinal; var layer: Conv2DLayer);
var
    j: cardinal;
begin
    {$ifdef __CONV2D_DEBUG}
    writeln('setW_i_Conv2D(', i, ')');
    {$endif}

    for j := 0 to layer.filters[i].w * layer.filters[i].h do
        layer.filters[i].aW[j] := w[j];
end;

{ Set filter[i], weight[j] of the given layer }
procedure setW_ij_Conv2D(const w: double; const i, j: cardinal; var layer: Conv2DLayer);
begin
    {$ifdef __CONV2D_DEBUG}
    writeln('setW_ij_Conv2D(', i, ', ', j, ')');
    {$endif}

    if (i < layer.nodes) and (j <= layer.filters[i].w * layer.filters[i].h) then
        layer.filters[i].aW[j] := w;
end;

{ Set filter[i]'s horizontal stride for the given layer }
procedure setHorzStride_i_Conv2D(const stride, i: cardinal; var layer: Conv2DLayer);
begin
    if i < layer.nodes then
    begin
        layer.filters[i].stride_h := stride;

        layer.outLen := outputLen_Conv2D(layer);                    //  Re-compute layer's output length and reallocate its output buffer
        SetLength(layer.aout, layer.outLen);
    end;
end;

{ Set filter[i]'s vertical stride for the given layer }
procedure setVertStride_i_Conv2D(const stride, i: cardinal; var layer: Conv2DLayer);
begin
    if i < layer.nodes then
    begin
        layer.filters[i].stride_v := stride;

        layer.outLen := outputLen_Conv2D(layer);                    //  Re-compute layer's output length and reallocate its output buffer
        SetLength(layer.aout, layer.outLen);
    end;
end;

{ Set the activation function for unit[i] of the given layer }
procedure setF_i_Conv2D(const func: byte; const i: cardinal; var layer: Conv2DLayer);
begin
    {$ifdef __CONV2D_DEBUG}
    writeln('setF_i_Conv2D(', func, ', ', i, ')');
    {$endif}

    if i < layer.nodes then
      layer.filters[i].f := func;
end;

{ Set the activation function parameter for unit[i] of the given layer }
procedure setA_i_Conv2D(const a: double; const i: cardinal; var layer: Conv2DLayer);
begin
    {$ifdef __CONV2D_DEBUG}
    writeln('setA_i_Conv2D(', a, ', ', i, ')');
    {$endif}

    if i < layer.nodes then
      layer.filters[i].alpha := a;
end;

{ Set the name of the given Convolutional Layer }
procedure setName_Conv2D(const n: array of char; var layer: Conv2DLayer);
var
    i: byte;
    lim: byte;
begin
    if length(n) < LAYER_NAME_LEN then
        lim := length(n)
    else
        lim := LAYER_NAME_LEN;

    for i := 0 to lim - 1 do
        layer.layerName[i] := n[i];
    layer.layerName[lim] := chr(0);
end;

{ Print the details of the given Conv2DLayer 'layer' }
procedure print_Conv2D(const layer: Conv2DLayer);
var
    i, x, y: cardinal;
begin
    {$ifdef __CONV2D_DEBUG}
    writeln('print_Conv2D()');
    {$endif}

    for i := 0 to layer.nodes - 1 do                                //  Draw each filter
    begin
        writeln('Filter '+itoa( i));
        for y := 0 to layer.filters[i].h - 1 do
        begin
            write('  [');
            for x := 0 to layer.filters[i].w - 1 do
            begin
                if layer.filters[i].aW[y * layer.filters[i].w + x] >= 0.0 then
                    write(' '+ flots(layer.filters[i].aW[y * layer.filters[i].w + x])+ ' ')
                else
                    write(flots(layer.filters[i].aW[y * layer.filters[i].w + x])+ ' ');
            end;
            writeln(']');
        end;
        write('  Func:  ');
        case layer.filters[i].f of
            RELU:                write('ReLU   ');
            LEAKY_RELU:          write('L.ReLU ');
            ASIGMOID:             write('Sig.   ');
            HYPERBOLIC_TANGENT:  write('tanH   ');
            SOFTMAX:             write('SoftMx ');
            SYMMETRICAL_SIGMOID: write('SymSig ');
            THRESHOLD:           write('Thresh ');
            LINEAR:              write('Linear ');
        end;
        writeln('');
        writeln('  Param: '+flots( layer.filters[i].alpha));
        writeln('  Bias:  '+flots( layer.filters[i].aW[layer.filters[i].h * layer.filters[i].w]));
    end;
end;

{ Return the layer's output length }
function outputLen_Conv2D(const layer: Conv2DLayer): cardinal;
var
    i: cardinal;
begin
    {$ifdef __CONV2D_DEBUG}
    writeln('outputLen_Conv2D()');
    {$endif}

    result := 0;
    for i := 0 to layer.nodes - 1 do
        result := result+ ((floor((layer.inputW - layer.filters[i].w) / layer.filters[i].stride_h)+ 1) *
                    (floor((layer.inputH - layer.filters[i].h) / layer.filters[i].stride_v) + 1) );
end;

{ Run the given input vector 'x' of length 'layer'.'inputW' * 'layer'.'inputH' through the Conv2DLayer 'layer'.
  The understanding for this function is that convolution never runs off the edge of the input,
  and that there is only one "color-channel."
  Output is stored internally in layer.out. }
function run_Conv2D(const xvec: array of double; var layer: Conv2DLayer): cardinal;
var
    i, o, c: cardinal;                                              //  Iterators for the filters, the output vector, and the cache
    s: cardinal;                                                    //  Cache iterator
    x, y: cardinal;                                                 //  Input iterators
    m, n: cardinal;                                                 //  Filter iterators
    filterOutputLen: cardinal;                                      //  Length of a single filter's output vector
    cache: array of double;                                         //  Output array for a single filter
    softmaxdenom: double;
    val: double;
begin
    {$ifdef __CONV2D_DEBUG}
    writeln('run_Conv2D(', layer.inputW, ', ', layer.inputH, ')');
    {$endif}

    o := 0;
    filterOutputLen := 0;

    for i := 0 to layer.nodes - 1 do                                //  For each filter
    begin
        c := 0;
        softmaxdenom := 0.0;
        filterOutputLen:= ((floor((layer.inputW - layer.filters[i].w) / layer.filters[i].stride_h) + 1) *
                             (floor((layer.inputH- layer.filters[i].h)/ layer.filters[i].stride_v)+1) );
        SetLength(cache, filterOutputLen);

        y := 0;
        while y <= layer.inputH - layer.filters[i].h do
        begin
            x := 0;
            while x <= layer.inputW - layer.filters[i].w do
            begin
                val := 0.0;
                for n := 0 to layer.filters[i].h - 1 do
                begin
                    for m := 0 to layer.filters[i].w - 1 do
                        val := val+
                         layer.filters[i].aW[n * layer.filters[i].w + m] * xvec[(y + n) * 
                                           layer.inputW + x + m];
                end;
                                                                    //  Add bias
                val := val+ layer.filters[i].aW[layer.filters[i].w * layer.filters[i].h];
                cache[c] := val;                                    //  Add the value to the cache
                c := c+ 1;
                //inc2(x, layer.filters[i].stride_h);
                x:= x+ layer.filters[i].stride_h;
            end;
            //inc(y, layer.filters[i].stride_v);
            y:= y+ layer.filters[i].stride_v;
        end;

        for s := 0 to c - 1 do                                      
        //  In case one of the units is a softmax unit,
            softmaxdenom := softmaxdenom+ exp(cache[s]); 
                                     //  compute all exp()'s so we can sum them.

        for s := 0 to c - 1 do
        begin
            case layer.filters[i].f of
                RELU:                 if cache[s] > 0.0 then layer.aout[o] := 
                                            cache[s] else layer.aout[o] := 0.0;
                LEAKY_RELU:           if cache[s] > 0.0 then layer.aout[o] := 
                                   cache[s] else layer.aout[o] := cache[s] * layer.filters[i].alpha;
                ASIGMOID:              layer.aout[o] := 
                               1.0 / (1.0 + exp(-cache[s] * layer.filters[i].alpha));
                HYPERBOLIC_TANGENT:   layer.aout[o] := 
                            (2.0 / (1.0 + exp(-2.0 * cache[s] * layer.filters[i].alpha))) - 1.0;
                SOFTMAX:              layer.aout[o] := exp(cache[s]) / softmaxdenom;
                SYMMETRICAL_SIGMOID:  layer.aout[o] := 
                 (1.0 - exp(-cache[s] * layer.filters[i].alpha)) / (1.0 + exp(-cache[s] * 
                                     layer.filters[i].alpha));
                THRESHOLD:            if cache[s] > layer.filters[i].alpha then layer.aout[i] := 
                                  1.0 else layer.aout[i] := 0.0;
                LINEAR:               layer.aout[o] := 
                                   cache[s] * layer.filters[i].alpha;
            end;
            o := o+ 1;
        end;
    end;

    result := layer.outLen;
end;
end.

//----code_cleared_checked_clean----