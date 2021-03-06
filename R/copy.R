#' Copy an Item in API Database
#' 
#' This function copies items in Xaxis for Publishers.
#'
#' @usage oas_copy(credentials, 
#'                     request_type='Campaign',
#'                      copy_attributes = NULL,
#'                      copy_data, verbose = FALSE)
#' @concept api copy
#' @importFrom methods as
#' @include utils.R
#' @param credentials a character string as returned by \link{oas_build_credentials}
#' @param request_type a character string in one of the supported 
#' object types for the API database list action
#' @param copy_attributes a named character vector of attributes 
#' to add to the Copy node. The only acceptable parameter is "recurring".
#' @param copy_data an XML document specifying the data to copy when creating the request_type
#' @param verbose a boolean indicating whether messages should be printed while making the request
#' @return A \code{logical} being TRUE if the copy was successful
#' @note See the documentation about creating recurring copies
#' @examples
#' \dontrun{
#' my_credentials <- oas_build_credentials('myaccount', 
#'                                         'myusername', 
#'                                         'mypassword')
#'                                     
#' campgn_copy <- oas_copy(credentials=credentials, 
#'                         request_type='Campaign', 
#'                         copy_data=list(newXMLNode('Id', 'oldCampaignId'), 
#'                                          newXMLNode('NewId', 'newCampaignId'), 
#'                                          newXMLNode('CopyCreatives', 'Y'), 
#'                                          newXMLNode('CopyNotifications', 'Y'), 
#'                                          newXMLNode('CopyScheduling', 'Y'), 
#'                                          newXMLNode('CopyTargeting', 'Y'),
#'                                          newXMLNode('CopyBilling', 'Y'), 
#'                                          newXMLNode('CopyPages', 'Y'), 
#'                                          newXMLNode('CopySiteTiers', 'Y'), 
#'                                          newXMLNode('CopyConversionProcesses', 'Y')))
#' }
#' @export
oas_copy <- function(credentials, 
                       request_type='Campaign',
                       copy_attributes = NULL,
                       copy_data, verbose = FALSE){
  
  adxml_node <- newXMLNode("AdXML")
  request_node <- newXMLNode("Request", 
                             attrs = c(type = request_type), 
                             parent = adxml_node)
  action_node <- newXMLNode(request_type,
                            attrs = c(action = 'copy'),
                            parent = request_node)
  copy_node <- newXMLNode('Copy', attrs= copy_attributes, parent = action_node)
  
  for (node in copy_data){
    addChildren(copy_node, node)
  }
  
  if(verbose)
    print(adxml_node)
  
  adxml_string <- as(adxml_node, "character")
  
  xmlBody <- request_builder(credentials=credentials, 
                             adxml_request=adxml_string)
  
  result <- perform_request(xmlBody)
  
  parsed_result <- copy_result_parser(result_text=result$text$value(), 
                                        request_type=request_type)
  
  return(parsed_result)
}

copy_result_parser <- function(result_text, request_type){
  
  # pull out the results and format as XML
  # this takes some redundant steps to get the AdXML recognized as XML for parsing
  doc <- xmlTreeParse(result_text, asText=T)
  result_body <- xmlToList(doc)$Body.OasXmlRequestResponse.result
  result_body_doc <- xmlParse(result_body)
  
  # Check for error
  errorcode <- NA
  errormessage <- NA
  try(errorcode <- xmlAttrs(getNodeSet(result_body_doc, 
                                       "//Exception")[[1]], 'errorCode'), silent = T)
  try(errormessage <- xmlValue(getNodeSet(result_body_doc, 
                                          "//Exception")[[1]]), silent = T)
  if(!is.na(errorcode) && !is.na(errormessage)){
    stop(paste0('errorCode ', errorcode, ": ", errormessage), call. = F)
  }
  
  # else simply return true as updated
  return(TRUE)
}