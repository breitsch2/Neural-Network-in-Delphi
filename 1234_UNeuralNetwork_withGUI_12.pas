unit UNeuralNetwork_mX4_GUI_1;
//https://github.com/DevTobias/Neural-Network-in-Delphi/blob/master/UNeuralNetwork.pas

//TODO: get the approriate MNIST Jpeg image  - aInputImage
//TODO: extract code literals to consts  - like 'network_data.txt'

interface

//uses
  //System.Classes, System.SysUtils, System.Math, Vcl.Dialogs, Winapi.Windows, Vcl.Graphics,
  //UVector;

{type
  t_vector  = UVector.t_vector;
  t_matrix  = UVector.t_matrix;
  t_array3d = UVector.t_array3d;  }
  
type
  t_vector  = array of extended;
  t_matrix  = array of t_vector;
  t_array3d = array of t_matrix;

//type
  //TTVector = class

  //public //Methoden UVector helper unit
    function subtractArray1( pMatrix1 : t_matrix; pMatrix2 : t_matrix ) : t_matrix; //overload;
    function subtractArray2( p3DArray1 : t_array3d; p3DArray2 : t_array3d ) : t_array3d; //overload;
    function addArray( p3DArray1 : t_array3d; p3DArray2 : t_array3d ) : t_array3d; //overload;
    function addArray1( pMatrix1 : t_matrix; pMatrix2 : t_matrix ) : t_matrix; //overload;
    function multiplyArray( pMatrix : t_matrix; pVector : t_vector ) : t_vector; //overload;
  
  //procedure loadNNForm; ----------------------------------------TForm1
//begin
type
  TForm1 = {class(}TForm;
  var
    Button1: TButton;
    ListBox1: TListBox;
    Button2: TButton;
    Edit1: TEdit;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Button3: TButton;
    Label1: TLabel;
    Label4: TLabel;
    Button4: TButton;
    Label5: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    Help1: TMenuItem;
    Contents1: TMenuItem;
    Index1: TMenuItem;
    Commands1: TMenuItem;
    Procedures1: TMenuItem;
    Keyboard1: TMenuItem;
    SearchforHelpOn1: TMenuItem;
    Tutorial1: TMenuItem;
    HowtoUseHelp1: TMenuItem;
    About1: TMenuItem;
    Edit2: TEdit;
    Button5: TButton;
    Edit3: TEdit;
       procedure TForm1Button1Click(Sender: TObject);
       procedure TForm1FormClose(Sender: TObject; var Action: TCloseAction);
       procedure TForm1FormCreate(Sender: TObject);
       procedure TForm1Button2Click(Sender: TObject);
       procedure TForm1Button3Click(Sender: TObject);
       procedure TForm1Button4Click(Sender: TObject);
       procedure TForm1Button5Click(Sender: TObject);
  //end;
  
type t_letter_list = array of TPicture;  

var
  Form1: TForm1;
  network : TNeuralNetwork;
  layerLengths : TStringList;
  inputImageList : {UReader.}t_letter_list;
  aInputImage : TPicture;  //for GUI image class
  aLetterList : t_letter_list;
  RESFOLDER: string;

const
  //dataBase = 'Ressourcen/Database/mnist_train.csv';
  //dataBase = 'Ressourcen/Database/emnist-letters-train.csv';
  //https://github.com/hailiang194/pytorch-emnist/blob/main/train.csv
  dataBase = 'C:\Program Files\Streaming\maxbox4\Import\emnisttrain.csv';

//type
  //TTNeuralNetwork = class
  //private //Attribute
  var
    weights : t_array3d;
    biases : t_matrix;
    activations : t_matrix;
    zActivations : t_matrix;
    expectedOutputVector : t_vector;

    gradientWeights : t_array3d;
    gradientBiases : t_matrix;
    gradientActivations : t_matrix;

    layerSizes : TStringList;
    dataInputList : TStringList;
    amountLayers : Integer;
    currentSolution : Integer;

  //public //Netzwerk erzeugen / initialisieren
    procedure {constructor} TTNeuralNetworkCreate( pSizes: TStringList ); //overload;
    procedure TTNeuralNetworkCreate1( pInputPath : String ); //overload;
    procedure {destructor} TTNeuralNetworkDestroy1; //override;
  //private
    procedure initializeWeightsAndBiases(); //virtual;
    procedure declareWeightsAndBiases(); //virtual;

  //public//Netzwerk speichern / auslesen
    procedure saveNetwork( pOutputPath : String );
    procedure loadNetwork( pInputPath : String );
  //private
    procedure saveWeightsAndBiases( pOutputPath : String ); //virtual;
    procedure saveNetworkData(pOutputPath : String ); //virtual;
    procedure readWeightsAndBiases( pInputPath : String ); //virtual;
    procedure readNetworkData( pInputPath : String ); //virtual;
    
  //public //Netzwerk Ausgabe berechnen
    function feedForward( pInputLayer : t_vector ) : t_vector; //virtual;

  //public //Netzwerk Trainieren
    procedure backpropagateNetwork(pBatchSize: Integer; pRounds: Integer; pDataPath : String ); //virtual;
  //private
    procedure calculateOutputLayerGradient( pLayerL, pLayerL_1 : Integer ); //virtual;
    procedure calculateHiddenLayerGradient( pLayerL, pLayerL_1 : Integer ); //virtual;
    procedure resetGradientArrays(); //virtual;
   
  //public //Netzwerk Testen
    function calculateHitRate( pStartIndex : Integer; pEndIndex : Integer ) : Real; //virtual;
    function calculateAverageCost( pStartIndex : Integer; pEndIndex : Integer ) : Real; //virtual;
    function getCurrentSolution( pType : String ) : String; //virtual;
    function getOutputSolution( pType : String): String; //virtual;
  //private
    function calculateCost( pOutputLayer : t_vector ) : Real; //virtual;

  //public //Netzwerk Datenbasis
    function getInputData( pIndex : Integer ) : String; //virtual;
    procedure loadInputData( pInputPath : String ); //virtual;
    function calculateInputActivations( pInputString : String ) : t_vector; //virtual;
    function getBitmapFromPixel( pInputSize : Integer; pIndex: Integer; pDataPath: String ) : TBitmap;
    // virtual;
   
  //private //Berechnungsfunktionen
    procedure NNSplit( pDelimiter: Char; pInputStr: String; pOutputList: TStrings ); //virtual;
    function multiplyMatrixWithVector( pWeightMatrix : t_matrix; pActivationVector : t_vector ) : 
                                                    t_vector; //virtual;
    function calculateSigmoid( pActivation : extended ) : extended; //virtual;
    function addVectorWithVector( pActivationVector, pBiasVector : t_vector ) : t_vector; //virtual;
    function calculateVectorSigmoid( pVector : t_vector ) : t_vector; //virtual;
    function calculateSigmoidPrime( pActivation : extended ) : extended; //virtual;
    function NNsubtractArray( pMatrix1 : t_matrix; pMatrix2 : t_matrix; pBatchSize : Integer )
                                                           : t_matrix; //overload;
    function NN2subtractArray( p3DArray1 : t_array3d; p3DArray2 : t_array3d; pBatchSize : Integer ) :
                                                                   t_array3d; //overload;
       //*)
  //end;


implementation

//-------- Matrix auf Vector multiplizieren (public) ----------------------------
function multiplyArray( pMatrix : t_matrix; pVector : t_vector ) : t_vector;

//var
//  I, J : Integer;
begin
 { for I := 0 to Length( pMatrix ) - 1 do
    for J := 0 to Length( pMatrix[ I ] ) - 1 do
      if ( I = 0 ) and ( J = 0 ) then
        t_vector[ I ] := ( t_vector[ J ] * pMatrix[ I ][ J ] )
      else
        t_vector[ I ] := t_vector[ I ] + ( t_vector[ J ] * pMatrix[ I ][ J ] );

  result := t_vector;
 }
end;

//+-----------------------------------------------------------------------------
//|         Vektoren subtrahieren
//+-----------------------------------------------------------------------------

//-------- 3D Array subtrahieren (public) --------------------------------------
function addArray( p3DArray1 : t_array3d; p3DArray2 : t_array3d ) : t_array3d;
var
  I, J, K : Integer;
begin
  for I := 0 to Length( p3DArray1 ) - 1 do
    for J := 0 to Length( p3DArray1[ I ] ) - 1 do
      for K := 0 to Length( p3DArray1[ I ][ J ] ) - 1 do
        p3DArray1[ I ][ J ][ K ] := p3DArray1[ I ][ J ][ K ] + p3DArray2[ I ][ J ][ K ];
  result := p3DArray1;
end;

//-------- Matrix subtrahieren (public) ----------------------------------------
function addArray1( pMatrix1 : t_matrix; pMatrix2 : t_matrix ) : t_matrix;
var I, J : Integer;
begin
  for I := 0 to Length( pMatrix1 ) - 1 do
    for J := 0 to Length( pMatrix1[ I ] ) - 1 do
      pMatrix1[ I ][ J ]:= pMatrix1[ I ][ J ] + pMatrix2[ I ][ J ];
  result := pMatrix1;
end;


//+-----------------------------------------------------------------------------
//|         Vektoren addieren
//+-----------------------------------------------------------------------------

//-------- 3D Array addieren (public) ------------------------------------------
function subtractArray2( p3DArray1 : t_array3d; p3DArray2 : t_array3d ) : t_array3d;
var I, J, K : Integer;
begin
  for I := 0 to Length( p3DArray1 ) - 1 do
    for J := 0 to Length( p3DArray1[ I ] ) - 1 do
      for K := 0 to Length( p3DArray1[ I ][ J ] ) - 1 do
        p3DArray1[ I ][ J ][ K ] := p3DArray1[ I ][ J ][ K ] - p3DArray2[ I ][ J ][ K ];
  result := p3DArray1;
end;

//-------- Matrix addieren (public) --------------------------------------------
function subtractArray1( pMatrix1 : t_matrix; pMatrix2 : t_matrix ) : t_matrix;
var I, J : Integer;
begin
  for I := 0 to Length( pMatrix1 ) - 1 do
    for J := 0 to Length( pMatrix1[ I ] ) - 1 do
      pMatrix1[ I ][ J ] := pMatrix1[ I ][ J ] - pMatrix2[ I ][ J ];
  result := pMatrix1;
end;


//+-----------------------------------------------------------------------------
//|        TT NeuralNetwork: Netzwerk erzeugen / initialisieren
//+-----------------------------------------------------------------------------

//-------- Create-New (public) -------------------------------------------------
procedure TTNeuralNetworkCreate( pSizes: TStringList ); begin

  //inherited Create;
  randomize();

  layerSizes := pSizes;
  amountLayers := layerSizes.Count;
  processmessagesOFF;
  writ('debug info: declareWeightsAndBiases start.');
  declareWeightsAndBiases();
  initializeWeightsAndBiases();
  processmessagesON;
  writ('debug info: declare & init WeightsAndBiases done...');

end;

//-------- Create-Avaible (public) ---------------------------------------------
procedure TTNeuralNetworkCreate1( pInputPath : String ); begin

  //inherited Create;
  randomize();
  loadNetwork( pInputPath );

end;

//-------- Objekt freigeben (public) -------------------------------------------
procedure {TNeuralNetwork.}TTNeuralNetworkDestroy1(); begin

 // self.layerSizes.Free;
  {self.}layerSizes.Free;
end;

  //t_vector  = array of extended;
  //t_matrix  = array of t_vector;
  //t_array3d = array of t_matrix;

Procedure SetArrayLength2Extend3(var arr: t_matrix; asize1, asize2: Integer);
var i: Integer;
begin setlength(arr, asize1);
   for i:= 0 to asize1-1 do SetLength(arr[i], asize2);
end;


//-------- Arrays deklarieren (private) ----------------------------------------
procedure {TNeuralNetwork.}declareWeightsAndBiases();
var I : Integer;
begin
  //Activations initialisieren
    //Matrix Array festlegen - Y(Anzahl Layer), X(Knoten pro Layer)
  setLength( activations, amountLayers );
  setLength( zActivations, amountLayers );
  setLength( gradientActivations, amountLayers );
  for I := 0 to amountLayers - 1 do begin
    setLength( activations[ I ], StrToInt( layerSizes[ I ] ) );
    setLength( zActivations[ I ], StrToInt( layerSizes[ I ] ) );
    setLength( gradientActivations[ I ], StrToInt( layerSizes[ I ] ) );
  end;

  //Biases initialisieren
  //Matrix Array festlegen - Y(Anzahl Layer), X(Knoten pro Layer)
  setLength( biases, amountLayers - 1 );
  setLength( gradientBiases, amountLayers - 1 );
  for I := 0 to amountLayers - 2 do begin
    setLength( biases[ I ], StrToInt( layerSizes[ I + 1 ] ) );
    setLength( gradientBiases[ I ], StrToInt( layerSizes[ I + 1 ] ) );
  end;

  //Weights initialisieren
    //3D Array festlegen - Z(Anzahl Layer), Y(Knoten Layer L+1), X(Knoten Layer L)
    //l+1 vor L damit feedForward einfach zu berechnen ist
  setLength( weights, amountLayers - 1 );
  setLength( gradientWeights, amountLayers - 1 );
  for I := 0 to amountLayers - 2 do begin
  //bugfix  -done
    //setLength( weights[ I ], StrToInt( layerSizes[ I + 1 ] ), StrToInt( layerSizes[ I ] ) );
    SetArrayLength2Extend3(weights[ I ],StrToInt(layerSizes[ I + 1]),StrToInt(layerSizes[ I ]));
    //setLength( gradientWeights[ I ], StrToInt( layerSizes[ I + 1 ] ), StrToInt( layerSizes[ I ] ) );
    SetArrayLength2Extend3(gradientWeights[I],StrToInt(layerSizes[I+1]),StrToInt(layerSizes[I]));
  end;

  //Output initialisieren
  setLength( expectedOutputVector, StrToInt( layerSizes[ amountLayers - 1 ] ) );
end;

//-------- InitializeNetwork-New (private) -------------------------------------
procedure initializeWeightsAndBiases();
var I, J, K : Integer;
begin
  //Biases initialisieren
    //Wete einsetzen - b = 0
    //Anzahl der Layer - Biases für jeden Knoten jedes Layers
  for I := 0 to amountLayers - 2 do
    for J := 0 to StrToInt( layerSizes[ I + 1 ] ) - 1 do
      biases[ I ][ J ] := RandG( 0, 1 ) * sqrt( 2 / Length( layerSizes[ I ] ) );

  //Weights initialisieren
    //Werte einsetzen - w = random * Wurzel aus 2 durch Anzahl der Knoten im Layer
    //Anzahl der Verbindungen - Weights Verbindung von Layer L zu Layer L+1
  for I := 0 to amountLayers - 2 do
    for J := 0 to StrToInt( layerSizes[ I ] ) - 1 do
      for K := 0 to StrToInt( layerSizes[ I + 1 ] ) - 1 do
        weights[ I ][ K ][ J ]:= RandG( 0, 1 ) * sqrt( 2 / Length( layerSizes[ I ] ) );
  writeln('debug info: init WeightsAndBiases --> declare and initialized..');
end;

//+-----------------------------------------------------------------------------
//|         NeuralNetwork: Netzwerk speichern / auslesen
//+-----------------------------------------------------------------------------

//-------- Save Network (public) -----------------------------------------------
procedure saveNetwork( pOutputPath : String ); begin

  saveNetworkData( pOutputPath );
  saveWeightsAndBiases( pOutputPath );
  writeln( 'Netzwerkdaten erfolgreich gespeichert!' );

end;

//-------- Save Network Connections (private) ----------------------------------
procedure saveWeightsAndBiases( pOutputPath : String );
var I, J, K : Integer;
  cacheOutput : String;
  outputList : TStringList;
begin
  outputList := TStringList.Create;
    //Biases
  cacheOutput := '';
  for I := 0 to amountLayers - 2 do begin
    for J := 0 to StrToInt( layerSizes[ I + 1 ] ) - 1 do
      cacheOutput := cacheOutput + FloatToStr( biases[ I ][ J ] ) + ' ';
    outputList.Add( cacheOutput );
    cacheOutput := '';
  end;
  outputList.SaveToFile( pOutputPath + 'biases.txt' );
  outputList.Clear;
  //Weights
  cacheOutput := '';
  for I := 0 to amountLayers - 2 do begin
    for J := 0 to StrToInt( layerSizes[ I + 1 ] ) - 1 do begin
      for K := 0 to StrToInt( layerSizes[ I ] ) - 1 do
        cacheOutput := cacheOutput + FloatToStr( weights[ I ][ J ][ K ] ) + ' ';
      outputList.Add( cacheOutput );
      cacheOutput := '';
    end;
    outputList.Add( '' );
  end;
  outputList.SaveToFile( pOutputPath + 'weights.txt' );
  outputList.Free;
end;

//-------- Save Network Data (private) -----------------------------------------
procedure saveNetworkData( pOutputPath : String );
var I : Integer;
    outputList : TStringList;
begin
  outputList := TStringList.Create;
  outputList.Add( IntToStr( amountLayers ) );
  for I := 1 to amountLayers do
    outputList.Add( layerSizes[ I - 1 ] );

  outputList.SaveToFile( pOutputPath + 'network_data.txt' );
  outputList.Free;
end;

//-------- Load Network (public) -----------------------------------------------
procedure loadNetwork( pInputPath : String ); begin

  readNetworkData( pInputPath );
  processmessagesOFF;
  writ('debug info: loadNN declareWeightsAndBiases start.');
  declareWeightsAndBiases();
  processmessagesON;
  readWeightsAndBiases( pInputPath );

end;

//-------- Read Network Connections (private) ----------------------------------
procedure readWeightsAndBiases( pInputPath : String );
var
  I, J, K, counter : Integer;
  inputList, cacheDataList : TStringList;

begin
  inputList := TStringList.Create;
  cacheDataList := TStringList.Create;

    //Biases
  inputList.LoadFromFile( pInputPath + 'biases.txt' );
  for I := 0 to inputList.Count - 1 do begin
    Split( ' ', inputList[ I ], cacheDataList ) ;
    for J := 0 to Length( biases[ I ] ) - 1 do
      {self.}biases[ I ][ J ] := StrToFloat( cacheDataList[ J ] );
  end;

   //Weights
  inputList.LoadFromFile( pInputPath + 'weights.txt' );
  K := 0; I := 0; counter := 0;
  while K < amountLayers - 1 do begin
    if inputList[ counter ] <> '' then begin
      Split( ' ', inputList[ counter ], cacheDataList ) ;
      for J := 0 to Length( weights[ K ][ I ] ) - 1 do
        weights[ K ][ I ][ J ] := StrToFloat( cacheDataList[ J ] );
      inc( I ); inc( counter );
    end else begin
      inc( K ); inc( counter );
      I := 0;
    end;
  end;
  inputList.Free; cacheDataList.Free;
end;

//-------- Read Network Data (private) -----------------------------------------
procedure readNetworkData( pInputPath : String );
var I : Integer;
  inputList : TStringList;

begin
  inputList := TStringList.Create;
  layerSizes := TStringList.Create;
  inputList.LoadFromFile( pInputPath + 'network_data.txt' );

  amountLayers := StrToInt( inputList[ 0 ] );
  for I := 1 to amountLayers do
    layerSizes.Add( inputList[ I ] );
  inputList.Free;
end;

//+-----------------------------------------------------------------------------
//|         NeuralNetwork: Aussage treffen
//+-----------------------------------------------------------------------------

//-------- calculateOutputLayer (public) ---------------------------------------
function feedForward( pInputLayer : t_vector ) : t_vector;
var I : Integer;
begin
  activations[ 0 ] := pInputLayer;
  zActivations[ 0 ] := pInputLayer;
  for I := 1 to amountLayers - 1 do begin
    zActivations[I]:= addVectorWithVector( multiplyMatrixWithVector( weights[ I - 1 ], 
                                    activations[ I - 1 ] ), biases[ I - 1 ] );
    activations[ I ]:= calculateVectorSigmoid( zActivations[ I ] );
  end;
  result := activations[ Length( activations ) - 1 ];
end;


//+-----------------------------------------------------------------------------
//|         NeuralNetwork: Trainieren
//+-----------------------------------------------------------------------------

//-------- Backprogagation (public) --------------------------------------------
procedure backpropagateNetwork( pBatchSize : Integer; pRounds : Integer; pDataPath : String );
var
  I, J, K, L, max, counter : Integer;
begin
  loadInputData( pDataPath );
  //max := pRounds * dataInputList.Count;   88799
  max := pRounds * 88799;

  for L := 1 to pRounds do begin
    counter := 0;
    for I := 0 to dataInputList.Count - 1 do begin
      if counter = pBatchSize - 1 then begin
        NN2subtractArray( weights, gradientWeights, pBatchSize );
        NNsubtractArray( biases, gradientBiases, pBatchSize );
        counter := 0;
        resetGradientArrays();   //Durchgang     //Derzeitige Stelle
        writeln( 'Durchgang: ' + IntToStr( L ) + '-' + IntToStr( I ) + ' - ' + 
          FloatToStr ( ( ( L - 1 ) * dataInputList.Count ) + I ) + '/' + FloatToStr( max ) + '-' + 
          FloatToStr(((((L - 1)* dataInputList.Count ) + I ) * 100 ) / max ) + '%' );
      end;

      for J := 0 to Length( gradientActivations ) - 1 do
        for K := 0 to Length( gradientActivations[ J ] ) - 1 do
          gradientActivations[ J ][ K ] := 0;

      feedForward( calculateInputActivations( getInputData( I ) ) );
      calculateOutputLayerGradient( Length( activations ) - 1, Length( activations ) - 2 );
      calculateHiddenLayerGradient( Length( activations ) - 2, Length( activations ) - 3 );

      inc( counter );
    end;
  end;
  writeln( 'Das Netzwerk hat ' + IntToStr( pRounds ) + ' Runden Lernen abgeschlossen!' );
end;

//-------- Gradient Descent - OutputLayer (private) ----------------------------
procedure calculateOutputLayerGradient( pLayerL, pLayerL_1 : Integer );
var I, J : Integer;
begin
  //Activations Layer-1
  for I := 0 to Length( activations[ pLayerL_1 ] ) - 1 do
    for J := 0 to Length( activations[ pLayerL ] ) - 1 do
      gradientActivations[ pLayerL_1 ][ I ] :=    gradientActivations[ pLayerL_1 ][ I ] + weights[ pLayerL_1 ][ J ][ I ] * calculateSigmoidPrime( zActivations[ pLayerL ][ J ] ) * ( 2 * ( activations[ pLayerL ][ J ] - expectedOutputVector[ J ] ) );

    //Weights and Biases
  for I := 0 to Length( activations[ pLayerL ] ) - 1 do begin
    for J := 0 to Length( activations[ pLayerL_1 ] ) - 1 do                                
      gradientWeights[ pLayerL - 1 ][ I ][ J ] := gradientWeights[ pLayerL - 1 ][ I ][ J ] +
               activations[ pLayerL_1 ][ J ] * calculateSigmoidPrime( zActivations[ pLayerL ][ I ] ) *
                               ( 2 * ( activations[ pLayerL ][ I ] - expectedOutputVector[ I ] ) );
      gradientBiases[ pLayerL - 1][ I ] :=  gradientBiases [ pLayerL - 1 ][ I ] +
                                               calculateSigmoidPrime( zActivations[ pLayerL ][ I ] ) * 
    ( 2 * ( activations[ pLayerL ][ I ] - expectedOutputVector[ I ] ) );
  end;
end;

//-------- Gradient Descent - HiddenLayer (private) ----------------------------
procedure calculateHiddenLayerGradient( pLayerL, pLayerL_1 : Integer );
var
  I, J : Integer;
  K : Integer;
begin
  for K := layerSizes.Count - 2 downTo 1 do begin
    for I := 0 to Length( activations[ pLayerL_1 ] ) - 1 do
      for J := 0 to Length( activations[ pLayerL ] ) - 1 do
              gradientActivations[ pLayerL_1 ][ I ] := gradientActivations[ pLayerL_1 ][ I ] +
               gradientActivations[ pLayerL ][ J ] * weights[ pLayerL_1 ][ J ][ I ] *
                calculateSigmoidPrime( zActivations[ pLayerL ][ J ] );

     {for I := 0 to Length( activations[ pLayerL_1 ] ) - 1 do
      for J := 0 to Length( activations[ pLayerL ] ) - 1 do
        gradientActivations[ pLayerL_1 ][ I ] :=    gradientActivations[ pLayerL_1 ][ I ] + weights[ pLayerL_1 ][ J ][ I ] * calculateSigmoidPrime( zActivations[ pLayerL ][ J ] ) * ( 2 * ( activations[ pLayerL ][ J ] - gradientActivations[ pLayerL ][ J ] ) );
        }

      //Weights and Biases
    for I := 0 to Length( activations[ pLayerL ] ) - 1 do begin
      for J := 0 to Length( activations[ pLayerL_1 ] ) - 1 do
        gradientWeights[ pLayerL_1 ][ I ][ J ] := gradientWeights[ pLayerL_1 ][ I ][ J ]  + 
         ( activations[ pLayerL_1][J] * gradientActivations[ pLayerL ][I] * 
        calculateSigmoidPrime( zActivations[ pLayerL ][ I ] ) );
      gradientBiases[ pLayerL - 1 ][ I ]:= gradientBiases[ pLayerL - 1 ][ I ]+ 
       (gradientActivations[ pLayerL ][I] * calculateSigmoidPrime( zActivations[ pLayerL ][ I ] ) );
    end;
    dec( pLayerL );
    dec( pLayerL_1 );
  end;
end;

//-------- Reset Arrays (private) ----------------------------------------------
procedure resetGradientArrays();
var I, J, K : Integer;
begin
  for I := 0 to Length( gradientWeights ) - 1 do
    for J := 0 to Length( gradientWeights[ I ] ) - 1 do
      for K := 0 to Length( gradientWeights[ I ][ J ] ) - 1 do
        gradientWeights[ I ][ J ][ K ] := 0;

  for I := 0 to Length( gradientBiases ) - 1 do
    for J := 0 to Length( gradientBiases[ I ] ) - 1 do
      gradientBiases[ I ][ J ] := 0;
end;


//+-----------------------------------------------------------------------------
//|         NeuralNetwork: Testen
//+-----------------------------------------------------------------------------

//-------- Get Expected Solution (public) --------------------------------------
function getCurrentSolution( pType : String ) : String;
var alphabet : String;

begin
  if UpperCase( pType ) = 'TLETTER' then begin
    alphabet := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    result := alphabet[ currentSolution ];
  end else result := IntToStr( currentSolution );

end;

//-------- Get Brightest Neuron (public) ---------------------------------------
function getOutputSolution( pType : String): String;
var
  I, layerIndex : Integer;
  maxActivation : Real;
  prediction : Integer;
  alphabet : String;
begin
  layerIndex := layerSizes.Count - 1;
  maxActivation := -1; prediction := -1;
  for I := 0 to StrToInt( layerSizes[ amountLayers - 1 ] ) - 1 do begin
    if activations[ layerIndex ][ I ] > maxActivation then begin
      maxActivation := activations[ layerIndex][ I ];
      prediction := I;
    end;
  end;

  if UpperCase( pType ) = 'TLETTER' then begin
    alphabet := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    result := alphabet[ prediction ];
  end else result := IntToStr( prediction );
end;

//-------- Average Test Cost (public) ------------------------------------------
function calculateAverageCost( pStartIndex : Integer; pEndIndex : Integer ): Real;
var I : Integer;
  cacheAverage : Real;
begin
  cacheAverage := 0;
  for I := pStartIndex to pEndIndex do begin
 // cacheAverage:= cacheAverage+ calculateCost(feedForward calculateInputActivations getInputData(I))));
  cacheAverage:= cacheAverage+ calculateCost(feedForward(calculateInputActivations(getInputData(I))));
    //writeLn( 'Cost: ' + IntToStr( I ) + '-' + FloatToStr( cacheAverage / I ) );
  end;
  result := cacheAverage / ( pEndIndex - pStartIndex );
end;

//-------- Average Hit rate (public) -------------------------------------------
function calculateHitRate( pStartIndex : Integer; pEndIndex : Integer ) : Real;
var I, correct : Integer;
begin
  correct := 0;
  for I := pStartIndex to pEndIndex do begin
    feedForward( calculateInputActivations( getInputData( I ) ) );
    if StrToInt( getCurrentSolution( 'TNumber' ) ) = StrToInt( getOutputSolution( 'TNumber' ) ) then
      inc( correct );
    //writeLn( 'Rate: ' + IntToStr( I ) + '-' + IntToStr( correct ) + '/' + IntToStr( I ) );
  end;
  result := 100 * ( correct / ( pEndIndex - pStartIndex ) )
end;

//-------- Single Test Cost (private) ------------------------------------------
function calculateCost( pOutputLayer : t_vector ) : Real;
var I : Integer;
  cost : Real;
begin
  cost := 0;
  for I := 0 to Length( pOutputLayer ) - 1 do
    cost := cost + sqr( pOutputLayer[ I ] - expectedOutputVector[ I ] );
  result := cost;
end;



//+-----------------------------------------------------------------------------
//|         NeuralNetwork: Datenbasis
//+-----------------------------------------------------------------------------

//-------- Read Input Data Line (public) ---------------------------------------
function getInputData( pIndex : Integer ) : String; begin

  result:= dataInputList.Strings[ pIndex ];

end;

//-------- Load Database (public) ----------------------------------------------
procedure loadInputData( pInputPath : String ); begin

  if dataInputList = nil then begin
    dataInputList := TStringList.Create;
    dataInputList.LoadFromFile( pInputPath );
  end;

end;

//-------- Interpret Greyvalue (public) ----------------------------------------
const
  baseValue = 255;

function calculateInputActivations( pInputString : String ) : t_vector;
var
  I : Integer;
  cacheDataList : TStringList;
  outputVector : t_vector;
begin
  cacheDataList := TStringList.Create;

  Split( ',', pInputString, cacheDataList ) ;
  {self.}currentSolution := StrToInt( cacheDataList[ 0 ] );
  setLength( outputVector, cacheDataList.Count - 1 );

  for I := 0 to Length( expectedOutputVector ) - 1 do
    if I = currentSolution then
      expectedOutputVector[ I ] := 1
    else
      expectedOutputVector[ I ] := 0;

  for I := 1 to cacheDataList.Count - 1 do
    if ( StrToInt( cacheDataList[ I ] ) <> 0 ) then
      outputVector[ I - 1 ] := StrToInt( cacheDataList[ I ] ) / baseValue
    else outputVector[ I - 1 ] := 0.0;

  result := outputVector;
  cacheDataList.Free;
end;

//-------- Greyvalue to Bitmap (public) ----------------------------------------
function getBitmapFromPixel( pInputSize: Integer; pIndex: Integer; pDataPath : String ) : TBitmap;
var
  picture : TBitmap;
  I, J : Integer;
  input : String;
  inputList : TStringList;
  colorValue, counter : Integer;

begin
  loadInputData( pDataPath);
  picture := TBitmap.Create;
  picture.SetSize( pInputSize, pInputSize );

  input := getInputData( pIndex  );
  inputList := TStringList.Create;
  Split( ',', input, inputList ) ;

  counter := 1;
  for I := 0 to pInputSize - 1 do
    for J := 0 to pInputSize - 1 do begin
      colorValue := 255 - StrToInt( inputList[ counter ] );
      picture.Canvas.Pixels[ I, J ]:= TColor( RGB( colorValue, colorValue, colorValue ) );
      inc( counter );
    end;
  inputList.Free;
  result := picture;
end;



//+-----------------------------------------------------------------------------
//|         NeuralNetwork: Berechnungsoperationen
//+-----------------------------------------------------------------------------

//-------- String Splitter (private) -------------------------------------------
procedure NNSplit( pDelimiter: Char; pInputStr: String; pOutputList: TStrings ) ; begin

   pOutputList.Clear;
   pOutputList.Delimiter       := pDelimiter;
   pOutputList.StrictDelimiter := True;
   pOutputList.DelimitedText   := pInputStr;

end;

//-------- multiply Matrix-Vector (private) ------------------------------------
function multiplyMatrixWithVector( pWeightMatrix : t_matrix; pActivationVector : t_vector ) : t_vector;

var
  I, J : Integer;
  multiVector : t_vector;
begin
  setLength( multiVector, Length( pWeightMatrix ) );

  for I := 0 to Length( pWeightMatrix ) - 1 do
    for J := 0 to Length( pWeightMatrix[ I ] ) - 1 do
      multiVector[ I ] := multiVector[ I ] + ( pActivationVector[ J ] * pWeightMatrix[ I ][ J ] );
  result := multiVector;
end;

//-------- add Vector-Vector (private) -----------------------------------------
function addVectorWithVector( pActivationVector, pBiasVector : t_vector ) : t_vector;
var I, arrayDimension : Integer;
  addVector : t_vector;

begin
  arrayDimension :=  Length( pActivationVector );
  setLength( addVector, arrayDimension );

  for I := 0 to arrayDimension - 1 do
    addVector[ I ] := pActivationVector[ I ] + pBiasVector[ I ];

  result := addVector;
end;

//-------- Subtract 3D Array (private) -----------------------------------------
function NN2subtractArray( p3DArray1 : t_array3d; p3DArray2 : t_array3d; pBatchSize : Integer ) : t_array3d;

var I, J, K : Integer;
begin
  for I := 0 to Length( p3DArray1 ) - 1 do
    for J := 0 to Length( p3DArray1[ I ] ) - 1 do
      for K := 0 to Length( p3DArray1[ I ][ J ] ) - 1 do
        p3DArray1[I][J][K]:= p3DArray1[I][J][K]- ( p3DArray2[ I ][ J ][ K ]/ pBatchSize );
  result := p3DArray1;
end;

//-------- Subtract Matrix (private) -------------------------------------------
function NNsubtractArray( pMatrix1 : t_matrix; pMatrix2 : t_matrix; pBatchSize : Integer ) : t_matrix;
var
  I, J : Integer;
begin
  for I := 0 to Length( pMatrix1 ) - 1 do
    for J := 0 to Length( pMatrix1[ I ] ) - 1 do
      pMatrix1[ I ][ J ] := pMatrix1[ I ][ J ] - ( pMatrix2[ I ][ J ]  / pBatchSize );
  result := pMatrix1;
end;

//-------- Sigmoid Vector (private) --------------------------------------------
function calculateVectorSigmoid( pVector : t_vector ) : t_vector;
var
  I, arrayDimension : Integer;
  sigVector : t_vector;
begin
  arrayDimension :=  Length( pVector );
  setLength( sigVector, arrayDimension );

  for I := 0 to arrayDimension - 1 do
    sigVector[ I ] := calculateSigmoid( pVector[ I ] );
  result := sigVector;
end;

//-------- Sigmoid function (private) ------------------------------------------
function calculateSigmoid( pActivation : extended ) : extended; begin

  result := 1 / ( 1 + Exp( -pActivation ) );
end;

//-------- Sigmoid function Derivative (private) -------------------------------
function calculateSigmoidPrime( pActivation : extended ) : extended; begin

  result := calculateSigmoid( pActivation ) * ( 1 - calculateSigmoid( pActivation ) );
end;


//implementation  GUI Form
//{$R *.dfm}

procedure TForm1Button1Click(Sender: TObject); begin

  {network.}backpropagateNetwork( 50, StrToInt( Edit2.Text ), dataBase );
  {network.}saveNetwork( RESFOLDER+'/Network/' );

end;

procedure fillListBox();
var outputArray : {UVector.}t_vector;
  I : Integer;
  alphabet : String;
begin
  alphabet := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  outputArray := feedForward(calculateInputActivations(getInputData(StrToInt( Edit1.Text ))));
  for I := 0 to Length( outputArray ) - 1 do
    ListBox1.Items.Add( alphabet[ I + 1 ] + '-' + FloatToStr( outputArray[ I ] ) );

  Label3.Caption := 'Output: ' + getOutputSolution( 'TLetter' );
  Label5.Caption := 'True Output: ' + getCurrentSolution( 'TLetter' );
end;

procedure TForm1Button2Click(Sender: TObject); begin

  {network.}loadInputData( dataBase );
  write('datalistsize: '+itoa(dataInputList.count));
  ListBox1.Clear;
  writ('debug btn 2 clicked.. ')
  image1.Picture.Bitmap.SetSize( 100, 100 );
  image1.Canvas.StretchDraw( Rect( 0, 0, 100, 100 ), 
               getBitmapFromPixel( 28, StrToInt( Edit1.Text), dataBase ) );

  fillListBox();

end;

procedure TForm1Button3Click(Sender: TObject); begin

  {network.}loadInputData( dataBase );
  Label1.Caption := 'Sicherheit: ' + FloatToStr( calculateHitRate( 0, 88799 ) ) + '%' ;
  Label4.Caption := 'Quallität: ' + FloatToStr( calculateAverageCost( 0, 88799 ) );

end;

procedure TForm1Button4Click(Sender: TObject); begin

  {network.}saveNetwork( RESFOLDER+'/Network/' );

end;


//+-----------------------------------------------------------------------------
//|         Scanner
//+-----------------------------------------------------------------------------

//-------- LoadFromFile (public) -----------------------------------------------
procedure loadFromFileR( pInputPath: String );
var jpegImage : TJPEGImage;

begin
  if {self.}aInputImage = nil then
    aInputImage := TPicture.Create;

  jpegImage := TJPEGImage.Create;
  jpegImage.LoadFromFile( pInputPath );

  //self.aInputImage.LoadFromFile( pInputPath );
  aInputImage.Bitmap.Assign( jpegImage );
  jpegImage.Free;
end;

//-------- Create-File (public) ------------------------------------------------
procedure {constructor} TReaderCreate( pInputPath: String ); begin

  //inherited Create;
  loadFromFileR( pInputPath );

end;

//-------- ResizePicture (public) ----------------------------------------------
procedure ResizePicture( pNewWidth, pNewHeight: Integer );
var bufferImage : TBitmap;
begin
  bufferImage := TBitmap.Create;
  try
    bufferImage.SetSize( pNewWidth, pNewHeight );
    bufferImage.Canvas.StretchDraw( Rect( 0, 0, pNewWidth, pNewHeight ), aInputImage.Bitmap );
    aInputImage.Bitmap.SetSize( pNewWidth, pNewHeight );
    aInputImage.Bitmap.Canvas.Draw( 0, 0, bufferImage );
  finally
    bufferImage.Free;
  end;
end;

function getAverageGreyValue( pRGBColor : Longint ) : Integer;
var cacheAverage : Integer;
begin
  cacheAverage:= Integer(getRValue( pRGBColor))+ Integer(getGValue( pRGBColor ))+ 
                                Integer(getBValue( pRGBColor ) );
  cacheAverage := cacheAverage div 3;
  result := cacheAverage;
end;

procedure improveQuality( pDifferenceLimit : Integer );
var
  I, J : Integer;
  color : Longint;
begin
  for I := 0 to {self.}aInputImage.Height - 1 do
    for J := 0 to aInputImage.Width- 1 do begin
      color := ColorToRGB( aInputImage.Bitmap.Canvas.Pixels[ J, I ] );

      if getAverageGreyValue( color ) + pDifferenceLimit >= 255 then
        aInputImage.Bitmap.Canvas.Pixels[ J, I ] := clWhite
      else
        aInputImage.Bitmap.Canvas.Pixels[ J, I ] := clBlack;
    end;
end;

//-------- savePicture (public) ------------------------------------------------
procedure savePicture( pOutputPath : String ); begin

  {self.}aInputImage.SaveToFile( pOutputPath );

end;

function LetterInRow( pIndex : Integer ) : Boolean;
var   I : Integer;
begin
  result := false;
  for I := 0 to aInputImage.Width - 1 do
    if aInputImage.Bitmap.Canvas.Pixels[ I, pIndex ] = clBlack then begin
      result := true;
      break;
    end;
end;

//-------- LetterInColumn (private) --------------------------------------------
function LetterInColumn( pIndex : Integer; pCachePicture : TPicture ) : Boolean;
var I : Integer;
begin
  result := false;
  for I := 0 to pCachePicture.Height - 1 do
    if pCachePicture.Bitmap.Canvas.Pixels[ pIndex, I ] = clBlack then begin
      result := true;
      break;
    end;
end;

//-------- CopyOriginalImage (private) -----------------------------------------
procedure CopyRowOriginalImage( var pImage : TPicture; pUpperLimit, pLowerLimit : Integer );
var I, J : Integer;
begin
  for I := 0 to pImage.Height - 1 do
    for J := 0 to aInputImage.Width - 1 do
      pImage.Bitmap.Canvas.Pixels[J,I]:= aInputImage.Bitmap.Canvas.Pixels[J,I+ pUpperLimit ];
end;


//-------- addPictureRow (private) ---------------------------------------------
procedure addPictureRow( var pArray : t_letter_list; pUpperLimit, pLowerLimit : Integer ); begin

  setLength( pArray, Length( pArray ) + 1 );

  pArray[ Length( pArray ) - 1 ]:= TPicture.Create;
  pArray[ Length( pArray ) - 1 ].Bitmap := TBitmap.Create;
  pArray[ Length( pArray ) - 1 ].Bitmap.Width := aInputImage.Width;
  pArray[ Length( pArray ) - 1 ].Bitmap.Height := pLowerLimit - pUpperLimit;
  CopyRowOriginalImage( pArray[ Length( pArray ) - 1 ], pUpperLimit, pLowerLimit );
  pArray[Length(pArray)- 1].SaveToFile(RESFOLDER+'\test_out1'+IntToStr(random(500))+ '.jpeg');
end;

//-------- CopyOriginalImage (private) -----------------------------------------
procedure CopyColumnOriginalImage( pOriginalImage : TPicture; var pCopyPicture : TPicture; pLeftLimit, pRightLimit : Integer );

var I, J : Integer;
begin
  for I := 0 to pCopyPicture.Height - 1 do
   for J := 0 to pCopyPicture.Width - 1 do
     pCopyPicture.Bitmap.Canvas.Pixels[J,I]:= pOriginalImage.Bitmap.Canvas.Pixels[J+ pLeftLimit,I];
end;


//-------- addPictureColumn (private) ------------------------------------------
procedure addPictureColumn( pPicture : TPicture; pLeftLimit, pRightLimit : Integer ); begin

  setLength( aLetterList, Length( aLetterList ) + 1 );
  aLetterList[ Length( aLetterList ) - 1 ]:= TPicture.Create;
  aLetterList[ Length( aLetterList ) - 1 ].Bitmap := TBitmap.Create;
  aLetterList[ Length( aLetterList ) - 1 ].Bitmap.Width := pRightLimit - pLeftLimit;
  aLetterList[ Length( aLetterList ) - 1 ].Bitmap.Height := pPicture.Height;

  CopyColumnOriginalImage( pPicture, aLetterList[Length( aLetterList )- 1], pLeftLimit, pRightLimit );
  aLetterList[Length( aLetterList )-1 ].SaveToFile(RESFOLDER+'\test_out2'+ 
                IntToStr( random( 500 ) ) + '.jpeg' );
end;


//-------- splitRows (private) -------------------------------------------------
procedure splitRows( var pCacheList : t_letter_list );
var I : Integer;
  upperLimit, lowerLimit : Integer;
  switchUpperLower : Boolean;
begin
  upperLimit := -1; switchUpperLower := true;
  for I := 0 to {self.}aInputImage.Height - 1 do
      if switchUpperLower then begin
        if LetterInRow( I ) then begin
          upperLimit := I;
          switchUpperLower := false;
        end
      end else begin
        if LetterInRow( I ) = false then begin
          lowerLimit := I;
          switchUpperLower := true;
          addPictureRow( pCacheList, upperLimit, lowerLimit );
        end
    end;
end;

//-------- splitColumns (private) ----------------------------------------------
procedure splitColumns( pCacheList : t_letter_list );
var
  I, J : Integer;
  leftLimit, rightLimit : Integer;
  switchLeftRight : Boolean;
begin
  leftLimit := -1; switchLeftRight := true;
  for I := 0 to Length( pCacheList ) - 1 do begin
    for J := 0 to pCacheList[ I ].Width - 1 do
        if switchLeftRight then begin
          if LetterInColumn( J, pCacheList[ I ] ) then begin
            leftLimit := J;
            switchLeftRight := false;
          end
        end else begin
          if LetterInColumn( J, pCacheList[ I ] ) = false then begin
            rightLimit := J;
            switchLeftRight := true;
            addPictureColumn( pCacheList[ I ], leftLimit, rightLimit );
          end
       end;
   end;
end;

//-------- ResizeCustomPicture (pubkic) ----------------------------------------
procedure ResizeCustomPicture( var pPicture : TPicture; pNewWidth, pNewHeight: Integer );
var bufferImage : TBitmap;
begin
  bufferImage := TBitmap.Create;
  try
    bufferImage.SetSize( pNewWidth, pNewHeight );
    bufferImage.Canvas.StretchDraw( Rect( 0, 0, pNewWidth, pNewHeight ), pPicture.Bitmap );
    pPicture.Bitmap.SetSize( pNewWidth, pNewHeight );
    pPicture.Bitmap.Canvas.Draw( 0, 0, bufferImage );
  finally
    bufferImage.Free;
  end;
end;


//-------- ResizePicture (public) ----------------------------------------------
procedure ResizeLetterList( pWidth, pHeight : Integer );
var I : Integer;
begin
  for I := 0 to Length( aLetterList ) - 1 do begin
    ResizeCustomPicture( aLetterList[ I ], 48, 48 );
    {self.}aLetterList[I].SaveToFile(RESFOLDER+'\test_out3'+ IntToStr(random(500))+ '.jpeg' );
  end;
end;

//-------- savePictureInDatabase (public) --------------------------------------
procedure savePictureInDatabase( pOutputPath : String );
var
  I, J, K : Integer;
  outputString : String;
  outputDatabase : TStringList;
  color : Longint; grey : String;
begin
  outputDatabase := TStringList.Create;
  for I := 0 to Length( aLetterList ) - 1 do begin
    outputString := '0,';
    for J := aLetterList[ I ].Width - 1 downto 0 do
      for K := aLetterList[ I ].Height - 1 downto 0 do begin
        color := aLetterList[ I ].Bitmap.Canvas.Pixels[ J, K ];
        grey := IntToStr( getAverageGreyValue( ColorToRGB( color ) ) );
        //grey := ( GetRValue( ColorToRGB( color ) ) ).ToString;
        outputString := outputString + grey + ',' ;
      end;
    outputDatabase.Add( outputString );
  end;
  outputDatabase.SaveToFile( pOutputPath );
  outputDatabase.Free;
end;

//-------- splitPicture (public) -----------------------------------------------
procedure splitPicture();
var
  rowList : t_letter_list;
 begin
  //setLength( rowList, 1 );
  splitRows( rowList );
  splitColumns( rowList );
end;

//var RESFOLDER: string;

procedure TForm1Button5Click(Sender: TObject);
var  reader : TReader;
begin
  //RESFOLDER:= exepath+'Ressourcen';
  TReaderCreate(RESFOLDER+'\mnisttest.jpeg' );
  {reader.}ResizePicture( 100, 100 );
  //reader.improveQuality( StrToInt( Edit3.Text ) );
  {reader.}improveQuality( 200 );
  {reader.}savePicture( RESFOLDER+'\mnisttest_out.jpeg' );
  {reader.}splitPicture;
  {reader.}ResizeLetterList( 28, 28 );
  {reader.}savePictureInDatabase(RESFOLDER+'\mnistdatabse.txt' );

  image1.Picture.Bitmap.SetSize( 100, 100 );
  image1.Canvas.StretchDraw( Rect( 0, 0, 100, 100 ), 
  {network.}getBitmapFromPixel(28,0,RESFOLDER+'\mnistdatabse.txt' ) );
end;


//+-----------------------------------------------------------------------------
//|         GUI
//+-----------------------------------------------------------------------------

procedure TForm1FormCreate(Sender: TObject);
//var
  //inputArray : UNeuralNetwork.t_vector;
begin
  Button1.Caption := 'Trainieren';
  Button2.Caption := 'Bestimmen';
  Button3.Caption := 'Testen';
  Button4.Caption := 'Speichern';
  Edit1.Clear;
  Edit2.Clear; 
  edit1.text:= '2';

  //  from  Debug/Ressourcen/Network/network_data.txt
  layerLengths := TStringList.Create;
  layerLengths.add( '4' );
  layerLengths.add( '784' );
  layerLengths.add( '75' );
  layerLengths.add( '75' );
  layerLengths.add( '26' );

  {layerLengths.add( '1' );
  layerLengths.add( '2' );
  layerLengths.add( '2' );
  layerLengths.add( '2' ); }

  {network :=} TTNeuralNetworkCreate( layerLengths );
  //network := TNeuralNetwork.Create( 'Ressourcen/Network/' );
  //TTNeuralNetworkCreate1(database );

  //AllocConsole;
  //writeln('Network correctly initialized!');

end;

procedure TForm1FormClose(Sender: TObject; var Action: TCloseAction); begin
  layerlengths.Free;
  //network.Free;
  TTNeuralNetworkDestroy1;
  writ('debug info: TTNeuralNetworkDestroy1...');
end;

//https://github.com/DevTobias/Neural-Network-in-Delphi/blob/master/UGui.pas
//https://github.com/DevTobias/Neural-Network-in-Delphi/blob/master/UGui.dfm
procedure loadNNForm;
begin
 Form1:= TForm1.create(self)
 with form1 do begin
  Left:= 0
  Top:= 0
  ClientHeight:= 435
  ClientWidth:= 474
  Color:= clBtnFace
  Font.Charset:= DEFAULT_CHARSET
  Font.Color:= clWindowText
  Font.Height:= -11
  Font.Name:= 'Tahoma'
  Font.Style:= []
  Menu:= MainMenu1
  OldCreateOrder:= False
  OnClose:= @TForm1FormClose;
  OnCreate:= @TForm1FormCreate;
  PixelsPerInch:= 96
  //TextHeight:= 13
  icon.loadfromresourcename(hinstance,'XNETWORK');
  Show;  
  Image1:= TImage.create(form1)
  with image1 do begin
  parent:= form1;
    Left:= 139
    Top:= 100
    Width:= 108
    Height:= 102
    AutoSize:= True
  end ;
  Label1:= TLabel.create(form1)
  with label1 do begin
   parent:= form1;
    Left:= 253
    Top:= 56
    Width:= 51
    Height:= 13
    Caption:= 'Sicherheit:'
  end;
  Label2:= TLabel.create(form1)
  with label2 do begin
   parent:= form1;
    Left:= 139
    Top:= 82
    Width:= 30
    Height:= 13
    Caption:= 'Input:'
  end;
  Label3:= TLabel.create(form1)
  with label3 do begin
   parent:= form1;
    Left:= 139
    Top:= 208
    Width:= 45
    Height:= 13
    Caption:= 'Output: -'
  end;
  Label4:= TLabel.create(form1)
  with label4 do begin
   parent:= form1;
    Left:= 253
    Top:= 75
    Width:= 44
    Height:= 13
    Caption:= 'Quallit'#228't:'
  end ;
  Label5:= TLabel.create(form1)
  with label5 do begin
   parent:= form1;
    Left:= 139
    Top:= 226
    Width:= 70
    Height:= 13
    Caption:= 'True Output: -'
  end ;
  Button1:= TButton.create(form1)
  with button1 do begin
   parent:= form1;
    Left:= 253
    Top:= 100
    Width:= 108
    Height:= 26
    Caption:= 'Button1'
    TabOrder:= 0
    OnClick:= @Tform1Button1Click;
  end;
   Button2:= TButton.create(form1)
  with button2 do begin
   parent:= form1;
    Left:= 138
    Top:= 25
    Width:= 108
    Height:= 26
    Caption:= 'Button2'
    TabOrder:= 1
    OnClick:= @Tform1Button2Click;
  end;
   Button3:= TButton.create(form1)
  with button3 do begin
   parent:= form1;
    Left:= 252
    Top:= 25
    Width:= 108
    Height:= 25
    Caption:= 'Button3'
    TabOrder:= 2
    OnClick:= @Tform1Button3Click;
  end ;
   Button4:= TButton.create(form1)
  with button4 do begin
   parent:= form1;
    Left:= 138
    Top:= 245
    Width:= 108
    Height:= 25
    Caption:= 'Button4'
    TabOrder:= 3
    OnClick:= @Tform1Button4Click;
  end ;
  Edit1:= TEdit.create(form1)
  with edit1 do begin
   parent:= form1;
    Left:= 139
    Top:= 56
    Width:= 108
    Height:= 21
    TabOrder:= 4
    Text:= 'Edit1'
    Hint:= 'Datenbasis Index'
    showhint:= true;
  end;
  ListBox1:= TListBox.create(form1)
  with listbox1 do begin
   parent:= form1;
    Left:= 24
    Top:= 25
    Width:= 108
    Height:= 286
    ItemHeight:= 13
    TabOrder:= 5
  end ;
  Edit2:= TEdit.create(form1)
  with edit2 do begin
   parent:= form1;
    Left:= 253
    Top:= 132
    Width:= 109
    Height:= 21
    TabOrder:= 6
    Text:= 'Edit2'
    Hint:= 'Lerndurchg'#228'nge';
    showhint:= true;
  end ;
  Button5:= TButton.create(form1)
  with button5 do begin
   parent:= form1;
    Left:= 312
    Top:= 216
    Width:= 95
    Height:= 25
    Caption:= 'Button5Reader'
    TabOrder:= 7
    OnClick:= @Tform1Button5Click;
  end;
  Edit3:= TEdit.create(form1)
  with edit3 do begin
   parent:= form1;
    Left:= 312
    Top:= 189
    Width:= 121
    Height:= 21
    TabOrder:= 8
    Text:= 'Edit3'
  end ;
  (*
  object MainMenu1: TMainMenu
    Left:= 352
    Top:= 65528
    object File1: TMenuItem
      Caption:= '&Datei'
      object New1: TMenuItem
        Caption:= '&Neues Netzwerk'
      end
      object Open1: TMenuItem
        Caption:= 'Netzwerk '#214'&ffnen...'
      end
      object Save1: TMenuItem
        Caption:= 'Netzwerk &Speichern'
      end
      object SaveAs1: TMenuItem
        Caption:= 'Netzwerk Speichern &unter...'
      end
      object N1: TMenuItem
        Caption:= '-'
      end
      object Exit1: TMenuItem
        Caption:= '&Beenden'
      end
    end
    object Help1: TMenuItem
      Caption:= '&Hilfe'
      object Contents1: TMenuItem
        Caption:= '&Inhalt'
      end
      object Index1: TMenuItem
        Caption:= 'Inde&x'
      end
      object Commands1: TMenuItem
        Caption:= '&Befehle'
      end
      object Procedures1: TMenuItem
        Caption:= '&Anleitungen'
      end
      object Keyboard1: TMenuItem
        Caption:= '&Tastatur'
      end
      object SearchforHelpOn1: TMenuItem
        Caption:= '&Suchen'
      end
      object Tutorial1: TMenuItem
        Caption:= '&Lernprogramm'
      end
      object HowtoUseHelp1: TMenuItem
        Caption:= '&Hilfe verwenden'
      end
      object About1: TMenuItem
        Caption:= 'In&fo...'
      end
    end *)
  end; //Tform
  TForm1FormCreate(self);
 end;


begin //@main

  writeln('sigmoid pretest: '+flots(calculateSigmoid(0.06868)));
  RESFOLDER:= exepath+'Ressourcen';
  LoadNNForm;
  //edit1.text:= '1';
  //Filllistbox;
  //https://www.quora.com/What-is-the-solution-of-2+%E2%88%9A3-2-%E2%88%9A3
  maxcalcF('(2 + sqrt(3))*(2 - sqrt(3))');

end.
end.

ref: https://github.com/DevTobias/Neural-Network-in-Delphi/blob/master/UNeuralNetwork.pas
     https://www.quora.com/What-is-the-solution-of-2+%E2%88%9A3-2-%E2%88%9A3
     https://www.nist.gov/itl/products-and-services/emnist-dataset
