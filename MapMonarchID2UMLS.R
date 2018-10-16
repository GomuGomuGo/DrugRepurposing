library("stringr")
library("ontologyIndex")
library("splitstackshape")
File <- "http://purl.obolibrary.org/obo/mondo.obo"
MondoOntology <- get_ontology(File, extract_tags = "everything")
## Generate Mondo ID and it's XREF ID's
MondoOntology_XREF = MondoOntology$xref
MondoOntology_XREF = do.call("rbind", lapply(MondoOntology_XREF, as.data.frame))
MondoOntology_XREF$MondoOntology_ID = row.names(MondoOntology_XREF)
row.names(MondoOntology_XREF) = NULL
MondoOntology_XREF = MondoOntology_XREF[,c(2,1)]
colnames(MondoOntology_XREF) = c("MondoOntology_ID", "MondoOntology_XREFID")
MondoOntology_XREF$MondoOntology_ID = gsub("\\..*","",MondoOntology_XREF$MondoOntology_ID)
MondoOntology_XREF$SOURCE = str_sub(MondoOntology_XREF$MondoOntology_XREFID,1,4)
## Limit to UMLS source and remove extra characters
Mondo2UMLS = MondoOntology_XREF[MondoOntology_XREF$SOURCE == "UMLS",]
Mondo2UMLS$MondoOntology_XREFID = gsub("UMLS:","",Mondo2UMLS$MondoOntology_XREFID)
Mondo2UMLS$MondoOntology_XREFID = trimws(Mondo2UMLS$MondoOntology_XREFID)
