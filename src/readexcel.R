##' read excel files more easily
##' @param file file
##' @param sheet sheet
##' @param big logical
##' @import XLConnect
##' @details read excel file in one commend. allows to read in multiple sheets
##' @rdname readexcel
##' @export
readexcel <- function(file,sheet=NULL,big=FALSE){
    if(big) options(java.parameters = "- Xmx1024m")
    require(XLConnect)  #from excel file
    wb <- XLConnect::loadWorkbook(file)
    sheetnam <- getSheets(wb)
    if(!is.null(sheet)){ 
        if(is.numeric(sheet)) sheetnam <- sheetnam[sheet] else sheetnam <- sheet
    }
    if(length(sheetnam)>1){
        l <- sapply(sheetnam,function(x) XLConnect::readWorksheet(wb,x))
    }else{
        l <- XLConnect::readWorksheet(wb, sheetnam)
    }
    remove(wb)
    return(l)
}