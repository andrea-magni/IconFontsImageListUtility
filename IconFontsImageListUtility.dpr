program IconFontsImageListUtility;

uses
  System.StartUpCopy,
  FMX.Forms,
  Forms.Main in 'Forms.Main.pas' {MainForm},
  Data.Metadata in 'Data.Metadata.pas' {MetadataData: TDataModule},
  Model in 'Model.pas',
  Icons.MaterialDesign in 'Icons.MaterialDesign.pas',
  Icons.FontAwesome in 'Icons.FontAwesome.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMetadataData, MetadataData);
  Application.Run;
end.
