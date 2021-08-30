# parte 1 = lista de servidores

$server = Get-Content servers.txt

 

 

foreach($server in $server){

 

$services = Get-Service -ComputerName $server |Where-Object {$_.Status -eq "Running"}

 

Restart-Computer -ComputerName $server -Force -Credential

 

 

Write-Host "Servidor Reiniciando"

 

# Aguarda 60 sgundos

sleep 60

 

#testando a conexão depois do boot

$conecta = Test-Connection -ComputerName $server -Count 1 -Quiet

 

    if (($conecta) -ne "True" ){

        Write-Host "O $server ESTA REINICIANDO"}

    else{

        Write-Host "O $server JÁ REINICIOU, VAMOS VALIDAR OS SERVIÇOS"

 

        foreach ($service in $service){

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

       

    } else {

       Write-Host "BOOT REALIZADO COM SUCESSO NO SERVIDOR $server"

            }

        }

    }

}
