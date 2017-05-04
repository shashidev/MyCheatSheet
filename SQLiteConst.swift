
import Foundation
public class SQLiteDataBase : NSObject{
   fileprivate let createTableQuery = "CREATE TABLE IF NOT EXISTS user(" +
                           "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                            "name VARCHAR(20)," +
                            "age VARCHAR(20)," +
                            "address VARCHAR(50));"
    public static let SQLite = SQLiteDataBase()
    @discardableResult func DBPath() -> String {
        let filemanger = FileManager.default
        let dirPath:AnyObject = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as AnyObject
        let dbPath = dirPath.appending("/myDatabase.sqlite")
        if filemanger.fileExists(atPath: dbPath){
            print("Database already Present.....!!!")
            return dbPath
        }
        return dbPath
    }
    
    func openDB()  -> OpaquePointer {
        var ptrOpaque:OpaquePointer? = nil
        if sqlite3_open(DBPath().cString(using: .utf8)!, &ptrOpaque) == SQLITE_OK  {
            print("Database Opened..!!!")
            return ptrOpaque!
        }
        print("Database opening failed")
        return ptrOpaque!
    }
    
   @discardableResult func createTable() -> Bool {
    var isTable:Bool = true
    var error : UnsafeMutablePointer<Int8>? = nil
    if sqlite3_exec(self.openDB(), createTableQuery, nil, nil, &error) == SQLITE_OK {
         print("Table Created")
      
        return isTable
    }
    print("Table creation failed ,Reason  \(error)")
    isTable = false
     return isTable
    }
    
    func insertValue(name:String,address:String,age:String) -> Void {
        
        var ptrOpaqueInsert:OpaquePointer? = nil
        let insertQuery = "INSERT INTO user(name,age,address)VALUES(?,?,?);"
        
        if sqlite3_prepare_v2(self.openDB(), insertQuery, -1, &ptrOpaqueInsert, nil) == SQLITE_OK{
            
            sqlite3_bind_text(ptrOpaqueInsert,1,name,-1,nil)
            sqlite3_bind_text(ptrOpaqueInsert,2,age,-1,nil)
            sqlite3_bind_text(ptrOpaqueInsert,3,address,-1,nil)
            
            if sqlite3_step(ptrOpaqueInsert) == SQLITE_DONE{
                
                print("Value inserted")
            }else{
              print("Insertion failed")
            }
        }
        sqlite3_finalize(ptrOpaqueInsert)
        sqlite3_close(openDB())
    }
    func selectAll(from table:String) -> Void {
        var ptrOpaque:OpaquePointer? = nil
        let selectQuery = "SELECT * FROM \(table);"
        if sqlite3_prepare_v2(self.openDB(), selectQuery, -1, &ptrOpaque, nil) == SQLITE_OK {
            while sqlite3_step(ptrOpaque) == SQLITE_ROW {
                let rowName = sqlite3_column_text(ptrOpaque, 1)
                let strName = String(cString:rowName!)
                let rowage = sqlite3_column_text(ptrOpaque, 2)
                let strage = String(cString:rowage!)
                let rowaddress = sqlite3_column_text(ptrOpaque, 3)
                let straddress = String(cString:rowaddress!)
                print(strName)
                 print(strage)
                 print(straddress)
            }
        }
        sqlite3_finalize(ptrOpaque)
        sqlite3_close(openDB())
    }
  
}


///Core Data Method Swift3

/*
 var getContext = {() -> NSManagedObjectContext in
 let appDelegate =  UIApplication.shared.delegate as! AppDelegate
 return appDelegate.persistentContainer.viewContext
 }
 func storeTranscription (name: String, address: String) {
 let context = getContext()
 let entity:Employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
 
 entity.name = "deva"
 entity.address = "Pune"
 do {
 try context.save()
 print("saved!")
 } catch let error as NSError  {
 print("Could not save \(error), \(error.userInfo)")
 } catch {
 
 }
 }
 func getTranscriptions () {
 let context = getContext()
 let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Employee")
 do {
 let searchResults = try context.fetch(fetchRequest)
 print ("num of results = \(searchResults.count)")
 for trans in searchResults as [NSManagedObject] {
 print("\(trans.value(forKey: "name"))")
 print("\(trans.value(forKey: "address"))")
 }
 } catch {
 print("Error with request: \(error)")
 }
 
 
 
 }

 */


/// Json Parsing Methods 


/*
 func getJsonData(_ url : String , complition:@escaping (_ response:NSArray)->Void , failure:(_ errorResponse:NSDictionary)->Void) -> Void {
 let semaphore = DispatchSemaphore(value: 0)
 let urlString = "https://jsonplaceholder.typicode.com/posts"
 DispatchQueue.global(qos: .userInitiated).sync {
 let url = URL(string: urlString)
 URLSession.shared.dataTask(with:url!) { (data, response, error) in
 if error != nil {
 print(error)
 } else {
 do {
 let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
 complition(parsedData)
 
 } catch let error as NSError {
 print(error)
 }
 }
 
 }.resume()
 _ = semaphore.wait(timeout: .distantFuture)
 
 
 }
 
 
 }
 func myData() -> NSArray {
 
 var jsonData:NSArray? = nil
 let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
 
 let data = NSData(contentsOf: url!)
 do {
 jsonData =  try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? NSArray
 //print(jsonData)
 
 } catch let error as NSError {
 print(error)
 }
 return jsonData!
 }*/


///Json Post method

/*
 
 func callWebServicesVerifyBiomatric() -> Void{
 let semaphore = DispatchSemaphore(value: 0)
 let  postString = [
 "biometric":["modality":"modality","biometricsData":"base64Image",
 "transactionContext":["timestamp":"base64Image",
 "latitude":"base64Image",
 "longitude":"base64Image",
 "eventType":"REMOTE ACCOUNT USER \("base64Image") VERIFICATION",
 "interactionChannel":"APP",
 "mfaOutcome":"SUCCESS",
 "mfaType":"mfaType",
 "deviceType":"",
 "deviceBrowser":"Simplifide",
 "deviceOS":"iOS"]
 ]
 ] as NSDictionary
 
 print("Post String : \(postString)")
 
 DispatchQueue.global(qos: .userInitiated).async {
 do {
 let jsonData = try JSONSerialization.data(withJSONObject: postString, options:.prettyPrinted)
 let request = NSMutableURLRequest(url: NSURL(string: "url")! as URL)
 request.httpMethod = "POST"
 
 request.setValue("", forHTTPHeaderField: "api_key")
 request.setValue("", forHTTPHeaderField: "api_secret")
 request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
 request.httpMethod = "POST"
 request.httpBody = jsonData
 let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
 if error != nil{
 print("Error -> \(error)")
 
 return
 }
 
 do {
 let result = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
 print(result)
 } catch {
 print("Error -> \(error)")
 }
 
 }
 task.resume()
 _ = semaphore.wait(timeout: DispatchTime.distantFuture)
 } catch {
 print(error)
 
 }
 }
 
 }

 */


