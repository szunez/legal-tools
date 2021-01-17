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
        $user = 'root';
        $password = 'root';
        $db = 'crim_db';
      
        $mysqli = new mysqli($host,$user,$password,$db);
      
        /* check connection */
        if (mysqli_connect_errno()) {
            printf("Connect failed: %s\n", mysqli_connect_error());
            exit();
        }
        $query = "SELECT def_nam, curr_off_lit, def_stnum_stnam, def_cty_st_zip FROM mailer WHERE hbk_id=$varID";
        $result = $mysqli->query($query);

        if ($result->num_rows > 0) {
          // output data of each row
          while($row = $result->fetch_assoc()) {
            echo "For the case where " . $row["def_nam"]. " has been charged with " . $row["curr_off_lit"]. 
            "<table>
              <tbody>
                <tr>
                  <td>Contact details:</td>
                </tr>;
                <tr>;
                  <td>" . $row["def_nam"]. "</td>
                </tr>;
                <tr>;
                  <td>" . $row["def_stnum_stnam"]. "</td>
                </tr>
                <tr>
                  <td>" . $row["def_cty_st_zip"]. "</td>
                </tr>
              </tbody>
            </table>";
          }
        }
        /* close connection */
        $mysqli->close();
      ?>
    </div>
  </form>
  </body>
</html>