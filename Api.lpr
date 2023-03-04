program Api;

{$MODE DELPHI}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Horse,
  Horse.BasicAuthentication,
  Horse.Jhonson,
  Horse.CORS,
  DataSet.Serialize.Config,
  DataSet.Serialize,
  udm, sysutils, contrato.router, dao.contrato, contrato.service;

procedure GetPing(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Ping');
end;

{procedure GetConectar(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
//   DM : TDM;
//   cnpj : string;

begin
{  try
    try
      try
        cnpj := Req.Params.Items['cnpj'];
      except
        cnpj := '0';
      end;
      DM := TDM.Create(nil);
      DM.Conexao.Connected := True;
      DM.qry.Close;
      DM.qry.SQL.Clear;
      DM.qry.SQL.Add('SELECT CT.CODCLI, CT.CHAVE FROM CONTRATO CT LEFT OUTER JOIN CLIENTE C ON C.CODIGO = CT.CODCLI');
      DM.qry.SQL.Add('WHERE (C.CNPJ_CPF = :CNPJ)');
      DM.qry.ParamByName('CNPJ').AsString := cnpj;
      DM.qry.Open;
      res.Send<TJSONArray>(DM.qry.ToJSONArray).Status(200);
      DM.qry.Close;

//      Res.Send('Conectou');
    except
      on Ex:Exception do
      begin
        Res.Send('Erro: '+ Ex.Message);
      end;
    end;
  finally
    DM.Conexao.Connected := False;
    FreeAndNil( DM );
  end;

end;
}

function Autenticacao(const AUsername, APassword: string): Boolean;
begin
  Result := AUsername.Equals('mafsistemas') and APassword.Equals('#Vida179701');
end;

begin
  THorse.Use(Jhonson('UTF-8'));
  THorse.Use(CORS);
  THorse.use(HorseBasicAuthentication(Autenticacao));
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDataSetSerializeConfig.GetInstance.Export.FormatDate := 'DD/MM/YYYY';

  THorse.Get('/ping', GetPing);
  contrato.router.RegistrarRotas;
  //THorse.Get('/conectar', GetConectar);
  {$ifdef horse_cgi}
     THorse.Listen;
  {$else}
     THorse.Listen(9000);
  {$endif}
end.
