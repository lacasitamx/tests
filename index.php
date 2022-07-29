<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Api Ip Basica</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor" crossorigin="anonymous">
<style>
body {
        background-image: url("https://images6.alphacoders.com/714/714146.jpg");
        background-repeat: no-repeat;
        background-size: 100%;
        background-attachment: fixed;
    }
</style>
</head>
  <body>
    <center>
        <div class="container">		
            <div class="painel">
                <div class="header">
                    <h2>
                        <font title color="black">Consultar IP</font>
                    </h2>
                </div>
                <div class="bodyer">
                    <form method="post"> 
                        <input class="form-control" id="cpf" placeholder="127.0.0.1" name="enviarcep" required><br>
                        <button id="consultar" class="btn btn-success">Consultar</button>
                    </form>
                </div>
            </div>
        </div>
 
  <?php
if(isset($_POST["enviarcep"])){
    $host = $_POST["enviarcep"];
    $host = str_replace("-", "", $host);
$curl = curl_init();
curl_setopt_array($curl, array(
CURLOPT_URL => "https://ipapi.co/".$host."/json/",
CURLOPT_POST => 1,
CURLOPT_ENCODING => 'gzip',
CURLOPT_HEADER => 0,
CURLOPT_NOBODY => 0,
CURLOPT_HTTPHEADER  => array(
    'accept: */*',
    // 'accept-encoding: gzip, deflate, br',
    'accept-language: pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7',
    'referer: https://ipapi.co/',
    'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36'
),
CURLOPT_FOLLOWLOCATION => 1,
CURLOPT_POSTFIELDS => '',
CURLOPT_RETURNTRANSFER => true,
CURLOPT_COOKIESESSION => 0,
CURLOPT_SSL_VERIFYPEER => 0,
CURLOPT_SSL_VERIFYHOST => 0, 
));
$result = curl_exec($curl);
curl_close($curl);

$js = json_decode($result, true);
$ip = $js["ip"];
$vrs = $js["version"];
$city = $js["city"];
$reg = $js["region"];
$pais = $js["country"];
$lat = $js["latitude"];
$long = $js["longitude"];
$asn = $js["asn"];
$org = $js["org"];

// print_r($result);
echo "<br/>
<table>
	<tr>
		<th colspan='3' class='badge text-bg-light'>Dados Básicos:</th>
	</tr>
	<tr>
	<td class='badge text-bg-info'>Ip: </td>
	<td class='badge text-bg-warning'> $ip</td>
</tr>
<tr>
	<td class='badge text-bg-info'>Versão: </td>
	<td class='badge text-bg-warning'> $vrs</td>
</tr>
<tr>
	<td class='badge text-bg-info'>Cidade: </td>
	<td class='badge text-bg-warning'> $reg</td>
</tr>
<tr>
	<td class='badge text-bg-info'>Região: </td>
	<td class='badge text-bg-warning'> $pais</td>
</tr>
<tr>
	<td class='badge text-bg-info'>Latitude: </td>
	<td class='badge text-bg-warning'> $lat</td>
</tr>
<tr>
	<td class='badge text-bg-info'>Longitude: </td>
	<td class='badge text-bg-warning'> $long</td>
</tr>
<tr>
	<td class='badge text-bg-info'>Asn: </td>
	<td class='badge text-bg-warning'> $asn</td>
</tr>
<tr>
	<td class='badge text-bg-info'>Organização: </td>
	<td class='badge text-bg-warning'> $org</td>
</tr>
</table>";
}
else {
    echo "<font class='badge text-bg-danger'>Ip não encontrado!</font>";
}
				
?>
</center>
</body>
<footer>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.5/dist/umd/popper.min.js" integrity="sha384-Xe+8cL9oJa6tN/veChSP7q+mnSPaj5Bcu9mPX5F5xIGE0DVittaqT5lorf0EI7Vk" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.min.js" integrity="sha384-kjU+l4N0Yf4ZOJErLsIcvOU2qSb74wXpOhqTvwVx3OElZRweTnQ6d31fXEoRD1Jy" crossorigin="anonymous"></script>
</footer>
</html>
