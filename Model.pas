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

end.
