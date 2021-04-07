<!doctype html>
<html lang="en">
  <head>
	<h1> Inference Results. </h1>
	<style>
		table, th, td {
		  border-collapse: collapse;
		}
		th, td {
		  padding: 10px;
		  text-align: left;
		}
		#A1 tr:nth-child(even) {
		  background-color: #eee;
		}
		#A1 tr:nth-child(odd) {
		 background-color: #fff;
		}
		#A1 th {
		  background-color: black;
		  color: white;
		  border: none;
		}
		.header {
			padding: 10px 16px;
			background: #ffff;
			color: #000000;
		}
		.content {
			padding: 16px;
		}
		.sticky {
			position: fixed;
			top: 0;
			width: 100%
		}
		.sticky + .content {
			padding-top: 102px;
		}
		audio {
			width: 200px;
		}
	</style>
 </head>
  <body>
   <div class="header" id="myHeader">
	<table>
	<tr>
	<?php
		$file = fopen("phrases.txt","r");

		while(! feof($file))
		{
			echo "<th> ". fgets($file). "</th>\n";
		}

		fclose($file);
	?> 
	</tr>
	</table>
	</div>
	<script>
		window.onscroll = function() {myFunction()};
		var header = document.getElementById("myHeader");
		var sticky = header.offsetTop;

		function myFunction() {
		  if (window.pageYOffset > sticky) {
			header.classList.add("sticky");
		  } else {
			header.classList.remove("sticky");
		  }
		}
	</script>
	</br>
<?php 
		foreach (glob("output_infer_*") as $filename) {
			echo "<h2>". "$filename" . "</h2>\n";
			echo "<table id=\"A1\">\n";
			echo "<tr>\n";
			foreach (glob($filename . "/*.wav") as $wavfilename) {
				echo "<td> <audio controls=\"\" ><source src=\"" . $wavfilename . "\"/></audio></td>\n";
			}
			echo "</tr>\n";
			echo "</table>\n";
		}

?>
</body>
</html>
