unit UReader_mX4;

interface

//uses
  //Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.StdCtrls, JPEG;

type
  t_letter_list = array of TPicture;

type
  TTReader = TObject; //class

  //private //Attribute
  var
    aInputImage : TPicture;
    aLetterList : t_letter_list;

  //public //Methoden
    //constructor Create(); overload;
    procedure {constructor} TReaderCreate( pInputPath: String ); //overload;
    procedure loadFromFile( pInputPath : String ); //virtual;

  //public
    procedure savePicture( pOutputPath : String ); //virtual;
    procedure savePictureInDatabase( pOutputPath : String ); //virtual;
    function getPicture() : TPicture; //virtual;
    function getLetterList() : t_letter_list;  //virtual;

  //public
    procedure improveQuality( pDifferenceLimit : Integer ); //virtual;
    procedure ResizePicture( pNewWidth, pNewHeight: Integer); //virtual;
    procedure ResizeCustomPicture( var pPicture : TPicture; pNewWidth, pNewHeight: Integer );
    procedure ResizeLetterList( pWidth, pHeight : Integer ); //virtual;
  //private
    function getAverageGreyValue( pRGBColor : Longint ) : Integer; //virtual;

  //public
    procedure splitPicture();  //virtual;
  //private
    procedure splitRows( var pCacheList : t_letter_list );  //virtual;
    procedure splitColumns( pCacheList : t_letter_list );  //virtual;
    function LetterInRow( pIndex : Integer ) : Boolean;  //virtual;
    function LetterInColumn( pIndex : Integer; pCachePicture : TPicture ) : Boolean;  //virtual;
    procedure addPictureRow( var pArray : t_letter_list; pUpperLimit, pLowerLimit : Integer );  //virtual;
    procedure addPictureColumn( pPicture : TPicture; pLeftLimit, pRightLimit : Integer );  //virtual;
    procedure CopyRowOriginalImage( var pImage : TPicture; pUpperLimit, pLowerLimit : Integer );  //virtual;
    procedure CopyColumnOriginalImage(pOriginalImage : TPicture; var pCopyPicture : TPicture; pLeftLimit, pRightLimit : Integer );  //virtual;

  //end;

implementation


//+-----------------------------------------------------------------------------
//|         Reader: Parser erzeugen
//+-----------------------------------------------------------------------------

//-------- Create-Empty (public) -----------------------------------------------
{constructor TReader.Create; begin

  inherited Create;

end; }

//-------- Create-File (public) ------------------------------------------------
procedure {constructor} TReaderCreate( pInputPath: String ); begin

  //inherited Create;

  loadFromFile( pInputPath );

end;

//-------- LoadFromFile (public) -----------------------------------------------
procedure loadFromFile( pInputPath: String );

var
  jpegImage : TJPEGImage;

begin

  if {self.}aInputImage = nil then
    aInputImage := TPicture.Create;

  jpegImage := TJPEGImage.Create;
  jpegImage.LoadFromFile( pInputPath );

  //self.aInputImage.LoadFromFile( pInputPath );
  aInputImage.Bitmap.Assign( jpegImage );

  jpegImage.Free;

end;




//+-----------------------------------------------------------------------------
//|         Reader: Zugriff auf Bild
//+-----------------------------------------------------------------------------

//-------- savePicture (public) ------------------------------------------------
procedure savePicture( pOutputPath : String ); begin

  {self.}aInputImage.SaveToFile( pOutputPath );

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

//-------- getPicture (public) -------------------------------------------------
function getPicture() : TPicture; begin

  result := {self.}aInputImage;

end;

//-------- getLetterList (public) ----------------------------------------------
function getLetterList() : t_letter_list; begin

  result := aLetterList;

end;




//+-----------------------------------------------------------------------------
//|         Reader: Bild bearbeiten
//+-----------------------------------------------------------------------------

//-------- ResizePicture (public) ----------------------------------------------
procedure ResizePicture( pNewWidth, pNewHeight: Integer );

var
  bufferImage : TBitmap;

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

//-------- improveQuality (pubkic) ---------------------------------------------
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

//-------- ResizeCustomPicture (pubkic) ----------------------------------------
procedure ResizeCustomPicture( var pPicture : TPicture; pNewWidth, pNewHeight: Integer );

var
  bufferImage : TBitmap;

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

var
  I : Integer;

begin

  for I := 0 to Length( aLetterList ) - 1 do begin
    ResizeCustomPicture( aLetterList[ I ], 48, 48 );
    {self.}aLetterList[I].SaveToFile( 'Ressourcen/Inputs/test_out3' + IntToStr(random(500)) + '.jpeg' );
  end;

end;

//-------- getAverageGreyValue (private) ---------------------------------------
function getAverageGreyValue( pRGBColor : Longint ) : Integer;

var
  cacheAverage : Integer;

begin

  cacheAverage := Integer( getRValue( pRGBColor ) ) + Integer( getGValue( pRGBColor ) ) + Integer( getBValue( pRGBColor ) );
  cacheAverage := cacheAverage div 3;

  result := cacheAverage;

end;




//+-----------------------------------------------------------------------------
//|         Reader: Bild in Buchstaben aufteilen
//+-----------------------------------------------------------------------------

//-------- splitPicture (public) -----------------------------------------------
procedure splitPicture();

var
  rowList : t_letter_list;

 begin

  //setLength( rowList, 1 );

  splitRows( rowList );
  splitColumns( rowList );

end;


//-------- splitRows (private) -------------------------------------------------
procedure splitRows( var pCacheList : t_letter_list );

var
  I : Integer;
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


//-------- LetterInRow (private) -----------------------------------------------
function LetterInRow( pIndex : Integer ) : Boolean;

var
  I : Integer;

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

var
  I : Integer;

begin

  result := false;
  for I := 0 to pCachePicture.Height - 1 do
    if pCachePicture.Bitmap.Canvas.Pixels[ pIndex, I ] = clBlack then begin
      result := true;
      break;
    end;

end;


//-------- addPictureRow (private) ---------------------------------------------
procedure addPictureRow( var pArray : t_letter_list; pUpperLimit, pLowerLimit : Integer ); begin

  setLength( pArray, Length( pArray ) + 1 );

  pArray[ Length( pArray ) - 1 ]:= TPicture.Create;
  pArray[ Length( pArray ) - 1 ].Bitmap := TBitmap.Create;
  pArray[ Length( pArray ) - 1 ].Bitmap.Width := aInputImage.Width;
  pArray[ Length( pArray ) - 1 ].Bitmap.Height := pLowerLimit - pUpperLimit;

  CopyRowOriginalImage( pArray[ Length( pArray ) - 1 ], pUpperLimit, pLowerLimit );

  pArray[Length(pArray)- 1].SaveToFile('Ressourcen/Inputs/test_out1'+IntToStr(random(500))+ '.jpeg');

end;

//-------- addPictureColumn (private) ------------------------------------------
procedure addPictureColumn( pPicture : TPicture; pLeftLimit, pRightLimit : Integer ); begin

  setLength( aLetterList, Length( aLetterList ) + 1 );

  aLetterList[ Length( aLetterList ) - 1 ]:= TPicture.Create;
  aLetterList[ Length( aLetterList ) - 1 ].Bitmap := TBitmap.Create;
  aLetterList[ Length( aLetterList ) - 1 ].Bitmap.Width := pRightLimit - pLeftLimit;
  aLetterList[ Length( aLetterList ) - 1 ].Bitmap.Height := pPicture.Height;

  CopyColumnOriginalImage( pPicture, aLetterList[ Length( aLetterList ) - 1 ], pLeftLimit, pRightLimit );

  aLetterList[Length( aLetterList )- 1 ].SaveToFile('Ressourcen/Inputs/test_out2'+ IntToStr( random( 500 ) ) + '.jpeg' );

end;


//-------- CopyOriginalImage (private) -----------------------------------------
procedure CopyRowOriginalImage( var pImage : TPicture; pUpperLimit, pLowerLimit : Integer );

var
  I, J : Integer;

begin

  for I := 0 to pImage.Height - 1 do
    for J := 0 to aInputImage.Width - 1 do
      pImage.Bitmap.Canvas.Pixels[ J, I ] := aInputImage.Bitmap.Canvas.Pixels[ J, I + pUpperLimit ];

end;

//-------- CopyOriginalImage (private) -----------------------------------------
procedure CopyColumnOriginalImage( pOriginalImage : TPicture; var pCopyPicture : TPicture; pLeftLimit, pRightLimit : Integer );

var
  I, J : Integer;

begin

  for I := 0 to pCopyPicture.Height - 1 do
   for J := 0 to pCopyPicture.Width - 1 do
     pCopyPicture.Bitmap.Canvas.Pixels[J ,I]:= pOriginalImage.Bitmap.Canvas.Pixels[J+ pLeftLimit,I];

end;

end.
