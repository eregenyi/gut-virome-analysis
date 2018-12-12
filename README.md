# Gut virome analysis scripts

R scripts for parsing, combining and visualizing the results of NGS shotgun virome data. 

Dummy datasets are provided, see ./data/input/ . 

## Hypothetical experimental setup

5-5 faecal samples of child A and child B were collected, and metadata was recorded along with them. These samples went through a viral enrichment lab protocol, and then their content was sequenced. The resulting NGS reads were assembled and passed through Blastn, Diamond, Virsorter and Metaphinder2. The Blastn and DIAMOND search results were further processed using KTClassifyBlast (KronaTools) to get the paths of the taxonomy. The reads were mapped back to the assembled contigs, to get the magnitudes. 

## Quick start

After installing R and RStudio (for version, see 'Software' bellow), clone the repository. <br />

```git clone https://github.com/eregenyi/gut-virome-analysis.git```

From the master script, all other scripts can be run swiftly and easily. <br />
Keep in mind that some parts of the code may need to be taylored to the needs of your own dataset. 

## Dummy input data

### blastn_taxidpaths.txt

A text file with two tab separated columns. The first contains the name of the node/contig, the second contains the taxid path of the organism the contig belongs to, as identified by Blastn.

### diamond_taxidpaths.txt

A text file with two tab separated columns. The first contains the name of the node/contig, the second contains the taxid path of the organism the contig belongs to, as identified by DIAMOND.

### metadata.csv

A spreadsheet with the metadata collected along with the samples. 


| Column | Content |
| --- | --- |
| Sample  |   (integer) sample number, 1-10. |
| Child  |   denotes the subject, child A or child B (a, b)   |
| Sampling date  |   the date (year-month-day) the sample was taken.   |
| Consistency  |   Stool consistency (for the sample) (1-8, where 1: very hard, 8: liquid)   |
| Solid_food  |   Binary variable, 0 still breastfeeding, child 1 underwent weaning.   |
| Diarrea  |   binary, 0 no, 1 yes   |
| Vomiting  |   binary, 0 no, 1 yes   |
| Listlessness  |   binary, 0 no, 1 yes   |
| Decreased appetite  |   binary, 0 no, 1 yes   |
| Fever  |   binary, 0 no, 1 yes   |
| Sick  |   binary, 0 no, 1 yes   |
| Doctors visit  |   binary, 0 no, 1 yes   |
| Hospitalisation  |   binary, 0 no, 1 yes   |
| Medication  |   binary, 0 no, 1 yes   |
| Drug  |  String, the prescribed drug   |
| Home  |  binary, 0 was not home, 1 was home   |
| Hospital  |  binary, 0 was not at the hospital, 1 was hospitalized/visited the hospital   |
| Nursery  |  binary, 0 did not go to nursery, 1 went to nursery   |
| Family  |  binary, 0 did not visit family, 1 visited family members   |
| Holiday  |  binary, 0 was not on a holiday, 1 was on a holiday  |

### metaphinder2.csv

A dummy version of the standard output of metaphinder2 (and metaphinder). To learn more about the tool please see: https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0163111

### virsorter.csv

A dummy version of the output of virsorter. Special characters (that the tool adds to the contig names) are removed. To learn more about the tool see: https://peerj.com/articles/985/

### taxids_genus.csv, taxids_family.csv, taxids_order.csv

Comma separated csv files, containing the taxid, name, name type (e.g. scientific) and rank of organisms at a genus, family and order level respectively. These files were generated using the official data from NCBI taxonomy as of March, 2018. 

### Mappings

This folder contains a .csv file for each sample. Such a file has 2 columns: the first contains all the contig names (that occur in any of the samples), the second contains the number of reads mapping to that contig in the particular sample the file corresponds to.

## Software

The scripts were written using: <br />
R version 3.4.0 <br />
RStudio Version 1.0.143

## Contributing

When contributing to the repository, please use the issues to discuss the changes you wish to make. All the contributions will be made under the [GPLv3 license](https://github.com/eregenyi/gut-virome-analysis/blob/master/LICENSE).

## License

GPLv3 License - see the [LICENSE](https://github.com/eregenyi/gut-virome-analysis/blob/master/LICENSE) file for details.
