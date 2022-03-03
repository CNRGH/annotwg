# AnnotWG

Efficiently annotate Whole Genome (WG) variants of a VCF file (ex: CADD score, GERP, Refseq, GnomAD etc.).

## Usage

```sh
$ annotwg -h

USAGE :
annotwg [options]
  -v, --vcf <file.vcf.gz>
        vcf file bgzipped and indexed with tabix to annotate [Mandatory]
  -r, --reference <ref.fa>
        indexed fasta genome reference (.fai or .dict format) [Mandatory]
  -a, --annot <bcf_annot_file>
        path to an annotation file (bcf format csi indexed) [Mandatory]
  -s, --annot-list <list>
        a comma separated list of INFO features to annotate (all annotations by default)
  -t, --thread <integer>
        number of threads used by annotwg (optional) [default:1]
  -d, --tempdir <path/to/tmp> [default: working directory]
        path to annotWG temporary directory
  -o, --output <out_file> [default: <input_prefix>.annotated.vcf.gz]
        output, e.g. annotated VCF file
  -O, --output-format <b|z>
        b: compressed BCF, z: compressed VCF [default : z]
  -m, --join-alleles
        Annotation of splitted alleles can skip variants with bcftools.
        This flag try to use bcftools norm -m + to join alleles to correct this behavior [optional flag]
  -I, --indexing
        perform on the fly csi index generation of the ouput [optional flag]
  -T, --tbi
        generate a tbi index instead of csi
  -p, --annotprefix <prefix>
        prefix that will be added before every annotation from the annotation file [default ''].
        example: if '-p annotwg_' the XXX field from the annotation source will be annotated annotwg_XXX.
  -i, --id
        Annotate the ID field from the annotation source (optional flag)
  -l, --compression-level
        The level of compression (integer from 1 to 9) (optional) [default:-1]
  -h, --help
        print help

DESCRIPTION :
AnnotWG annotate a WG bgzipped and tabixed VCF file

EXAMPLE :
annotwg -v file.vcf.gz -r ref.fasta -a annot.bcf
```

## Licensing

See the [LICENSE](LICENSE) file for licensing information as it pertains to files in this repository.

http://www.cecill.info/index.en.html

## Installation

### Required Dependencies
The main dependency is bcftools.

Complete dependency list:
- htslib
- bcftools
- gawk
- grep
- coreutils
- bash

### Basic Installation
```sh
git clone https://gitlab.com/cnrgh/annotwg.git
cd annotwg
./install.sh #to install as root or ./install.sh --prefix /path/to/my/install/ (see './install.sh -h' for more details)
annotwg -h # to check if the install worked
```

### Installation with dependancies using conda
```sh
git clone https://gitlab.com/cnrgh/annotwg.git
cd annotwg
conda env create -f annotwgcondaenv.yml
conda activate annotwg
./install.sh # or ./install.sh --prefix /path/to/my/install/ (see './install.sh -h' for more details)
annotwg -h # to check if the install worked
```

