unit Model;

interface

uses Classes, SysUtils;

type
  TFontEntry = record
    id: string;
    name: string;
    codepoint: string;
    aliases: TArray<string>;
    tags: TArray<string>;
    author: string;
    version: string;

    function sanitized_name: string;
    function ToConstDeclaration: string;
    function ToRecordConstDeclaration(const AIndex: Integer;
      const AValuesOnly: Boolean = False): string;
    function ToIndexedPropertyDeclaration(const AName: string;
      const AType: string;
      const AIndex: Integer): string;
    function AliasesToStringConst: string;
  end;

  TFontEntries = TArray<TFontEntry>;

implementation

{ TFontEntry }

uses StrUtils, System.Character;

function IsReservedWord(const AIdentifier: string): Boolean;
const
  ReservedWords: array of string = [
      'and', 'array', 'as', 'asm', 'begin', 'case', 'class', 'const', 'constructor'
    , 'destructor', 'dispinterface', 'div', 'do', 'downto', 'else', 'end', 'except'
    , 'exports', 'file', 'finalization', 'finally', 'for', 'function', 'goto', 'if'
    , 'implementation', 'in', 'inherited', 'initialization', 'inline', 'interface'
    , 'is', 'label', 'library', 'mod', 'nil', 'not', 'object', 'of', 'or', 'out'
    , 'packed', 'procedure', 'program', 'property', 'raise', 'record', 'repeat'
    , 'resourcestring', 'set', 'shl', 'shr', 'string', 'then', 'threadvar', 'to'
    , 'try', 'type', 'unit', 'until', 'uses', 'var', 'while', 'with', 'xor'];
var
  LIdentifier, LWord: string;
begin
  Result := False;
  LIdentifier := AIdentifier.ToLower;
  for LWord in ReservedWords do
    if LWord = LIdentifier then
      Exit(True);
end;

function TFontEntry.AliasesToStringConst: string;
var
  LIndex: Integer;
  LAliasesLine: string;
  LAlias: string;

begin
  Result := string.Join(',',  aliases);
  if Result.Length >= 255 then
  begin
    Result := '';
    LAliasesLine := '';
    for LIndex := 0 to Length(aliases)-1 do
    begin
      LAlias := aliases[LIndex];

      if Length(LAliasesLine) + Length(LAlias) + 1 >= 255 then
      begin
        if Result <> '' then
          Result := Result + sLineBreak + ' + ';
        Result := Result + LAliasesLine.QuotedString;

        LAliasesLine := '';
      end;

      if LAliasesLine <> '' then
        LAliasesLine := LAliasesLine + ',';

      LAliasesLine := LAliasesLine + LAlias;
    end;

    if LAliasesLine <> '' then
    begin
        if Result <> '' then
          Result := Result + sLineBreak + ' + ';
        Result := Result + LAliasesLine.QuotedString;

        LAliasesLine := '';
    end;

  end
  else
   Result := Result.QuotedString;
end;

function TFontEntry.sanitized_name: string;
begin
  Result := name.Replace('-', '_', [rfReplaceAll]);
  if IsReservedWord(Result) then
    Result := '&' + Result;
  if (Result.Length > 0) and Result.Chars[0].IsNumber then
    Result := '_' + Result;
end;

function TFontEntry.ToConstDeclaration: string;
begin
  Result := 'const '
    + sanitized_name +': Integer = $' + codepoint
    +'; // ' + name
    + IfThen(Length(aliases) > 0, ', aliases: ' + string.Join(', ',  aliases));
end;

function TFontEntry.ToIndexedPropertyDeclaration(const AName, AType: string;
  const AIndex: Integer): string;
begin
//    property one: TIconEntry index 0 read GetItem;
  Result := 'property ' + AName + ': ' + AType + ' index ' + AIndex.ToString + ' read GetEntry;';
end;

function TFontEntry.ToRecordConstDeclaration(const AIndex: Integer;
  const AValuesOnly: Boolean = False): string;
var
  LValues: string;
  LAliases: string;
begin
  // const account: TIconEntry = (name: 'account'; codepoint: $F0004; index: -1; aliases: 'a,b,c');
  // (name: 'account'; codepoint: $F0004; index: -1; aliases: 'a,b,c')

  LAliases := AliasesToStringConst;

  LValues := '('
    + 'name: ' + name.QuotedString
    + '; codepoint: $' + codepoint
    + '; index: ' + AIndex.ToString
    + '; aliases: ' + LAliases
    + ')';

  Result :=
      IfThen(not AValuesOnly, 'const ' + sanitized_name +': TIconEntry')
    + IfThen(not AValuesOnly, ' = ' + LValues, LValues)
    + IfThen(not AValuesOnly, ';');
end;

end.
