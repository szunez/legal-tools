<html>
  <body>
    <form action="" method="get">
    <input type="text" name="varID" placeholder="Enter ID# from our letter">
    <input type="submit" name="submit" value="submit">
    <br>
    <div>
      <?php
        $varID = $_GET['varID'];
        $host = 'db';  //the name of the mysql service inside the docker file.
        $user = 'devuser';
        $password = 'devpass';
        $db = 'test_db';
      
        $mysqli = new mysqli($host,$user,$password,$db);
      
        /* check connection */
        if (mysqli_connect_errno()) {
            printf("Connect failed: %s\n", mysqli_connect_error());
            exit();
        }
        $query = "SELECT CASE_CAUSE, STYLE, TYPE_ACTION_OFFENSE FROM cases WHERE id=$varID";
        $result = $mysqli->query($query);

        if ($result->num_rows > 0) {
          // output data of each row
          while($row = $result->fetch_assoc()) {
            echo "Case/Cause#: " . $row["CASE_CAUSE"]. " - " . $row["STYLE"]. ", " . $row["TYPE_ACTION_OFFENSE"]. "<br>";
          }
        }
        /* close connection */
        $mysqli->close();
      ?>
    </div>
  </form>
  </body>
</html>