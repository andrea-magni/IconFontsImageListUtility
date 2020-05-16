unit Forms.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, StrUtils
, Model, FMX.Layouts, System.Actions, FMX.ActnList
;

type
  TMainForm = class(TForm)
    AniIndicator1: TAniIndicator;
    Layout1: TLayout;
    FontAwesomeURLEdit: TEdit;
    ImportFontAwesomeButton: TButton;
    ImportMaterialDesignButton: TButton;
    MaterialDesignURLEdit: TEdit;
    Layout2: TLayout;
    CodeMemo: TMemo;
    TemplateMemo: TMemo;
    MaterialDesignUnitNameEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MaterialDesignTypeNameEdit: TEdit;
    FontAwesomeUnitNameEdit: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    FontAwesomeTypeNameEdit: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Layout3: TLayout;
    SaveButton: TButton;
    SaveDialog1: TSaveDialog;
    ActionList1: TActionList;
    SaveAction: TAction;
    procedure ImportMaterialDesignButtonClick(Sender: TObject);
    procedure ImportFontAwesomeButtonClick(Sender: TObject);
    procedure SaveActionExecute(Sender: TObject);
    procedure SaveActionUpdate(Sender: TObject);
  private
    FLastGeneratedUnitName: string;
  protected
    function ExpandTemplate(const ATemplate, AUnitName, ATypeName: string;
      const Entries: TFontEntries): string;
  public
    procedure AfterConstruction; override;

  end;


var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses Data.Metadata;

procedure TMainForm.AfterConstruction;
begin
  inherited;
  FLastGeneratedUnitName := '';
end;

function TMainForm.ExpandTemplate(const ATemplate, AUnitName, ATypeName: string;
  const Entries: TFontEntries): string;
var
  LDeclarations: TArray<string>;
begin
  Result := ATemplate
    .Replace('%UnitName%', AUnitName, [rfReplaceAll, rfIgnoreCase])
    .Replace('%TypeName%', ATypeName, [rfReplaceAll, rfIgnoreCase])
    .Replace('%Count%', Length(Entries).ToString, [rfReplaceAll, rfIgnoreCase])
  ;

  LDeclarations := [];
  for var Entry in Entries do
    LDeclarations := LDeclarations + ['    ' + Entry.ToConstDeclaration];

  Result := Result
    .Replace('%Declarations%', string.Join(sLineBreak, LDeclarations), [rfIgnoreCase]);
end;

procedure TMainForm.ImportFontAwesomeButtonClick(Sender: TObject);
begin
  AniIndicator1.Enabled := True;
  MetadataData.RetrieveAndParseFA(FontAwesomeURLEdit.Text
  , procedure (Entries: TFontEntries)
    begin
      AniIndicator1.Enabled := True;
      CodeMemo.Lines.BeginUpdate;
      try
        CodeMemo.Lines.Clear;
        CodeMemo.Text :=
          ExpandTemplate(TemplateMemo.Text
          , FontAwesomeUnitNameEdit.Text
          , FontAwesomeTypeNameEdit.Text
          , Entries);

        FLastGeneratedUnitName := FontAwesomeUnitNameEdit.Text;
      finally
        CodeMemo.Lines.EndUpdate;
      end;
      AniIndicator1.Enabled := False;
    end
  , procedure (Error: Exception)
    begin
      AniIndicator1.Enabled := False;
      CodeMemo.Text := Error.ToString;
    end
  );
end;

procedure TMainForm.ImportMaterialDesignButtonClick(Sender: TObject);
begin
  AniIndicator1.Enabled := True;
  MetadataData.RetrieveAndParseMD(MaterialDesignURLEdit.Text
  , procedure (Entries: TFontEntries)
    begin
      AniIndicator1.Enabled := True;
      CodeMemo.Lines.BeginUpdate;
      try
        CodeMemo.Lines.Clear;
        CodeMemo.Text :=
          ExpandTemplate(TemplateMemo.Text
          , MaterialDesignUnitNameEdit.Text
          , MaterialDesignTypeNameEdit.Text
          , Entries);

        FLastGeneratedUnitName := MaterialDesignUnitNameEdit.Text;
      finally
        CodeMemo.Lines.EndUpdate;
      end;
      AniIndicator1.Enabled := False;
    end
  , procedure (Error: Exception)
    begin
      AniIndicator1.Enabled := False;
      CodeMemo.Text := Error.ToString;
    end
  );
end;

procedure TMainForm.SaveActionExecute(Sender: TObject);
begin
  SaveDialog1.FileName := FLastGeneratedUnitName + '.pas';
  if SaveDialog1.Execute then
    CodeMemo.Lines.SaveToFile(SaveDialog1.FileName, TEncoding.ANSI);
end;

procedure TMainForm.SaveActionUpdate(Sender: TObject);
begin
  SaveAction.Enabled := FLastGeneratedUnitName <> '';
end;

end.
