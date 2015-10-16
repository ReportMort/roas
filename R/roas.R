#' roas: Open Ad Stream API from R
#'
#' roas is a convience wrapper around with Open Ad Stream (OAS) API
#' 
#' @docType package
#' @name roas
#' @import XML
#' @importFrom RCurl basicHeaderGatherer basicTextGatherer curlPerform curlEscape
#' @keywords package
#' @seealso XML RCurl
#' @examples
#' \dontrun{
#' 
#' # dataframes will return factors unless override
#' options(stringsAsFactors = F)
#' 
#' my_credentials <- build_credentials(account=myaccount, 
#'                                     username=myusername, 
#'                                     password=mypassword)
#' 
#' my_list_of_sites <- list_request(credentials=my_credentials, request_type='Site')
#' 
#' list_100_pages <- list_request(credentials=my_credentials, request_type='Page', 
#'                                search_criteria_attributes = c(pageSize=100))
#'                                   
#' list_by_criteria <- list_request(credentials=my_credentials, request_type='Page', 
#'                                  search_criteria_attributes = c(pageSize=100), 
#'                                  search_criteria=list(newXMLNode("Domain", "mySite"), 
#'                                                       newXMLNode("Url", "001"), 
#'                                                       newXMLNode("SectionId", "Ar%ves"), 
#'                                                       newXMLNode("SiteId", "ApiSite"), 
#'                                                       newXMLNode("Description", "My Page"), 
#'                                                       newXMLNode("LocationKey", "7"), 
#'                                                       newXMLNode("WhenCreated", 
#'                                                                  attrs = c(condition = "GT"), 
#'                                                                  '2014-12-31'), 
#'                                                       newXMLNode("WhenModified", 
#'                                                                  attrs = c(condition = "GT"), 
#'                                                                  '2013-12-31')))
#'                                                                  
#' country_criteria_node = newXMLNode("Country")
#' country_code_node = newXMLNode("Code", "US", parent = country_criteria_node)
#' list_city_codes_by_country <- list_code_request(credentials=my_credentials, code_type='City', 
#'                                                 search_criteria_attributes = c(pageSize="1000"), 
#'                                                 search_criteria=list(country_code_node)
#' )
#' 
#' }
NULL