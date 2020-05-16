unit Data.Metadata;

interface

uses
  System.SysUtils, System.Classes, System.JSON
, MARS.Core.JSON
, Model
;

type
  TMetadataData = class(TDataModule)
  private
  protected
    procedure Retrieve(const AURL: string;
      const ACompletionHandler: TProc<TJSONValue>;
      const AErrorHandler: TProc<Exception>);

    procedure ParseMD(const AJSON: TJSONArray; const AProcessor: TProc<TFontEntries>);
    procedure ParseFA(const AJSON: TJSONObject; const AProcessor: TProc<TFontEntries>);
  public
    procedure RetrieveAndParseMD(const AURL: string;
      const AProcessor: TProc<TFontEntries>;
      const AErrorHandler: TProc<Exception>);

    procedure RetrieveAndParseFA(const AURL: string;
      const AProcessor: TProc<TFontEntries>;
      const AErrorHandler: TProc<Exception>);
  end;

var
  MetadataData: TMetadataData;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  MARS.Client.Client.Net, MARS.Rtti.Utils, MARS.Core.Utils,
  MARS.Client.Resource.JSON;

{ TMetadataData }

procedure TMetadataData.ParseFA(const AJSON: TJSONObject;
  const AProcessor: TProc<TFontEntries>);
var
  LEntries: TFontEntries;
  LPair: TJSONPair;
  LEntry: TFontEntry;
begin
  if not Assigned(AProcessor) or not Assigned(AJSON) then
    Exit;

  LEntries := [];

  for LPair in AJSON do
  begin
    LEntry.name := LPair.JsonString.Value;
    LEntry.codepoint := (LPair.JsonValue as TJSONObject).ReadStringValue('unicode');
    LEntries := LEntries + [LEntry];
  end;

  AProcessor(LEntries);
end;

procedure TMetadataData.ParseMD(const AJSON: TJSONArray;
  const AProcessor: TProc<TFontEntries>);
begin
  if not Assigned(AProcessor) or not Assigned(AJSON) then
    Exit;

  AProcessor(AJSON.ToArrayOfRecord<TFontEntry>);
end;

procedure TMetadataData.Retrieve(const AURL: string;
  const ACompletionHandler: TProc<TJSONValue>;
  const AErrorHandler: TProc<Exception>
);
begin
  TMARSNetClient.GetJSONAsync<TJSONValue>(AURL, '', '', [], nil
  , ACompletionHandler
  , AErrorHandler
  );
end;

procedure TMetadataData.RetrieveAndParseFA(const AURL: string;
  const AProcessor: TProc<TFontEntries>; const AErrorHandler: TProc<Exception>);
begin
  Retrieve(AURL
  , procedure (JSON: TJSONValue)
    begin
      ParseFA(JSON as TJSONObject, AProcessor);
    end
  , AErrorHandler
  );
end;

procedure TMetadataData.RetrieveAndParseMD(const AURL: string;
  const AProcessor: TProc<TFontEntries>;
  const AErrorHandler: TProc<Exception>);
begin
  Retrieve(AURL
  , procedure (JSON: TJSONValue)
    begin
      ParseMD(JSON as TJSONArray, AProcessor);
    end
  , AErrorHandler
  );
end;

end.
