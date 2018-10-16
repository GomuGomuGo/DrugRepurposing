library("stringr")
library("ontologyIndex")
library("splitstackshape")
File <- "http://purl.obolibrary.org/obo/mondo.obo"
MondoOntology <- get_ontology(File, extract_tags = "everything")
### Get the list of Disease Ontology Names
MondoOntology_DB = MondoOntology$name
MondoOntology_DB = data.frame(MondoOntology_ID = names(MondoOntology_DB), Disease_Name = MondoOntology_DB
                              ,stringsAsFactors = FALSE)
## Remove the Row Names from the MondoOntology_DB DataFrame
row.names(MondoOntology_DB) = NULL
MondoOntology_DB$Disease_Name = toupper(MondoOntology_DB$Disease_Name)
MondoOntology_DB = MondoOntology_DB[order(MondoOntology_DB$MondoOntology_ID),]
MondoOntology_DB$SOURCE = str_sub(MondoOntology_DB$MondoOntology_ID,1,5)

## Generate Disease Ontology DataFrame for DOID and the XREF
MondoOntology_XREF = MondoOntology$xref
MondoOntology_XREF = do.call("rbind", lapply(MondoOntology_XREF, as.data.frame))
MondoOntology_XREF$MondoOntology_ID = row.names(MondoOntology_XREF)
row.names(MondoOntology_XREF) = NULL
MondoOntology_XREF = MondoOntology_XREF[,c(2,1)]
colnames(MondoOntology_XREF) = c("MondoOntology_ID", "MondoOntology_XREFID")
MondoOntology_XREF$MondoOntology_ID = gsub("\\..*","",MondoOntology_XREF$MondoOntology_ID)
MondoOntology_XREF$SOURCE = str_sub(MondoOntology_XREF$MondoOntology_XREFID,1,4)

### Get Mondo to UMLS and Mondo to DOID
Mondo2DOID = MondoOntology_XREF[MondoOntology_XREF$SOURCE == "DOID",]
Mondo2UMLS = MondoOntology_XREF[MondoOntology_XREF$SOURCE == "UMLS",]
Mondo2UMLS$MondoOntology_XREFID = gsub("UMLS:","",Mondo2UMLS$MondoOntology_XREFID)
Mondo2UMLS$MondoOntology_XREFID = trimws(Mondo2UMLS$MondoOntology_XREFID)
