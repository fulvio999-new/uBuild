
/*

Function used to manage the application database where are saved the configured jenkins url(s)

*/

 function getDatabase() {
    return LocalStorage.openDatabaseSync("uBuild_db", "1.0", "StorageDatabase", 1000000);
 }


 /* create the necessary tables */
 function createTables() {

     var db = getDatabase();
     db.transaction(
        function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS jenkins_data(id INTEGER PRIMARY KEY AUTOINCREMENT, jenkins_name TEXT, jenkins_url TEXT)');
        });
 }


 /* Insert default jenkins url only if they are not alrteady imported.
    Return true if the import is done */
 function insertDefaultJenkinsUrl(){

     if(settings.defaultDataImported == false) {

         insertNewJenkins("UBPorts", "http://ci.ubports.com");
         insertNewJenkins("Ubuntu", "https://core-apps-jenkins.ubuntu.com/");

         return true;
     }else
         return false;
 }


 /* Insert informations for a new jenkins  */
 function insertNewJenkins(jenkins_name, jenkins_url){

        var db = getDatabase();
        var res = "";
        db.transaction(function(tx) {

            var rs = tx.executeSql('INSERT INTO jenkins_data (jenkins_name, jenkins_url) VALUES (?,?);', [jenkins_name, jenkins_url]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            } else {
                res = "Error";
            }
        }
        );
        return res;
  }


  /* Update informations about a previously saved Jenkins */
  function updateJenkins(jenkins_id,jenkins_name, jenkins_url){

       var db = getDatabase();
       var res = "";

       db.transaction(function(tx) {
           var rs = tx.executeSql('UPDATE jenkins_data SET jenkins_name=?, jenkins_url=? WHERE id=?;', [jenkins_name,jenkins_url,jenkins_id]);
           if (rs.rowsAffected > 0) {
               res = "OK";
           } else {
               res = "Error";
           }
       }
       );
       return res;
  }


  /* delete a jenkins informations */
  function deleteJenkinsUrl(jenkins_id){
        var db = getDatabase();

        db.transaction(function(tx) {
            var rs = tx.executeSql('DELETE FROM jenkins_data WHERE id =?;',[jenkins_id]);            
           }
        );
  }

  /* load ALL the saved Jenkins url and insert them in the model shown in the combo box */
  function loadAllJenkinsUrl(){

      jenkinsUrlComboModel.clear();
      var db = getDatabase();
      var rs = "";

      db.transaction(function(tx) {
           rs = tx.executeSql('select jenkins_name, jenkins_url from jenkins_data');
         }
      );

      if(rs.rows.length === 0){
          jenkinsUrlComboModel.append({"name" : "NO URL FOUND", "description" : "----" } );
      }else{

          for(var i =0;i < rs.rows.length;i++) {
              jenkinsUrlComboModel.append({"name" : rs.rows.item(i).jenkins_name, "description" : rs.rows.item(i).jenkins_url } );
              /* console.log("Added name: "+rs.rows.item(i).jenkins_name +" URL: "+rs.rows.item(i).jenkins_url); */
          }
      }
  }


  /* load ALL the saved JenkUrl to be edited in the configuration page */
  function loadAllJenkinsUrlForEditing(){

       savedJenkinsUrlListModel.clear();
       var db = getDatabase();
       var rs = "";

       db.transaction(function(tx) {
           rs = tx.executeSql('select id, jenkins_name, jenkins_url from jenkins_data');
           }
       );

       for(var i =0;i < rs.rows.length;i++) {
           savedJenkinsUrlListModel.append({"jenkins_url_id" : rs.rows.item(i).id, "display_name" : rs.rows.item(i).jenkins_name, "url" : rs.rows.item(i).jenkins_url } );
           //console.log("Added name: "+rs.rows.item(i).jenkins_name +" URL: "+rs.rows.item(i).jenkins_url);
       }

  }


 /* Remove ALL saved Jenkins URL */
 function deleteAllJenkinsUrl(){

        var db = getDatabase();

        db.transaction(function(tx) {
          var rs = tx.executeSql('DELETE FROM jenkins_data;');
         }
       );

       loadAllJenkinsUrl(); //refresh combo      
 }
