$server = Get-Content servers.txt

 

foreach($server in $server){

 

$service = Get-Service -ComputerName $server |Where-Object {$_.Status -eq "Running"}

 

Restart-Computer -ComputerName $server -Force

 

Write-Host "Servidor $server reiniciando ..."

 

# Aguardar o tempo de 60 segundos para que o serviço de RDP baixe ou baixar o serviço antes de reiniciar a máquina ai sim pode-se retirar o sleep 60 abaixo:

 

sleep 90

 

#testando a conexao depois do boot

 

$conecta = Test-Connection -ComputerName $server -Count 1 -Quiet

 

    if (($conecta) -ne "True" ){

                                 Write-Host "O $server ESTA REINICIANDO"

                       }

    else{

         do {

              $rdp = Test-NetConnection $server -CommonTCPPort RDP -ErrorAction Continue;  

             Write-Host "Aguardando Subir RDP ...";

             ($rdp).TCPTestSucceeded;

            }

         while ( ($rdp).TCPTestSucceeded -ne "True" )

        

        Write-Host "O $server JA REINICIOU, VAMOS VALIDAR OS SERVICOS"

        

        # o sleep abaixo é obrigatório para garantir que os serviços já subiram

        sleep 30

 

        foreach ($service in $service){

        sleep 1

 

        $status = Get-Service $service.Name -ComputerName $server

        if ($status.Status -ne "Running") {

                                             Write-Host "O service" $service.Name "nao esta rodando"

                                             Write-Host "Iniciando o processo de start do $service"

             try {

                  Get-Service $service -ComputerName $server |Start-Service -ErrorAction Stop

                 }

 

             catch {

                    Write-Host "Ocorreu erro para subir o servico" $service.Name

                   }

         }  

  }  # fechamento de laco do foreach service in service

 

  }  # senao do if conect ne True

  Write-Host "BOOT REALIZADO COM SUCESSO NO SERVIDOR $server"

}  # fechamento de laco do foreach server in server
 
