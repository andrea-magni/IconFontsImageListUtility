program IconFontsImageListUtility;

uses
  System.StartUpCopy,
  FMX.Forms,
  Data.Metadata in 'Source\Data.Metadata.pas' {MetadataData: TDataModule},
  Forms.Main in 'Source\Forms.Main.pas' {MainForm},
  Model in 'Source\Model.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMetadataData, MetadataData);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
