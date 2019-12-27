Download Wscript.Arguments(0),Wscript.Arguments(1)
Sub Download(url,target)
  Const adTypeBinary = 1
  Const adSaveCreateOverWrite = 2
  Dim http,ado
  Set http = CreateObject("Msxml2.ServerXMLHTTP")
  http.open "GET",url,False
  http.send
  Set ado = createobject("Adodb.Stream")
  ado.Type = adTypeBinary
  ado.Open
  ado.Write http.responseBody
  ado.SaveToFile target
  ado.Close
End Sub
