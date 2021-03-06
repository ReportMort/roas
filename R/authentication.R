#' Build Credentials String
#' 
#' This function returns a formatted string that should be supplied 
#' when making requests to the API to authenticate the user
#'
#' @usage oas_build_credentials(account=getOption("roas.account"), 
#'                          username=getOption("roas.username"), 
#'                          password=getOption("roas.password"))
#' @concept api login credentials
#' @param account a character string of your OAS account name
#' @param username a character string of your OAS username that has API enabled access permissions
#' @param password a character string of your password for the OAS username specified
#' @return A \code{character}, formatted as XML, that should be supplied when making requests to the API
#' @examples
#' \dontrun{
#' my_credentials <- oas_build_credentials(account='myaccountname', 
#'                                     username='myusername', 
#'                                     password='mypassword')
#' }
#' @export
oas_build_credentials <- function(account=getOption("roas.account"), 
                                  username=getOption("roas.username"), 
                                  password=getOption("roas.password")){
  
  if(is.null(account) || is.null(username) || is.null(password)){
    message('account, username, and password must not be null')
    message('consider setting these using options(roas.account = "{account name here}"')
  }
  
  stopifnot(!is.null(account), !is.null(username), !is.null(password))
  
  return(paste0('<?xml version="1.0" encoding="UTF-8"?>
                <env:Envelope xmlns:n1="', getOption("roas.namespace"), '" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">',
                '<env:Body>
                <n1:',  getOption("roas.method_name"), ' xmlns:n1="',  getOption("roas.namespace"), '">',
                '<String_1>', account,  '</String_1>
                <String_2>', username, '</String_2>
                <String_3>', password, '</String_3>'))
}