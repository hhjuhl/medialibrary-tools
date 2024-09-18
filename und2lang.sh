#!/bin/bash

counter=0
force_processing=false

# Function to display the help message
function display_help() {
    echo -e "\nUsage: ./und2lang.sh [OPTIONS]\n"
    echo -e "Options:"
    echo -e "  -s <sprogkode>     Specify the ISO 639-2 language code (e.g., dan for Danish)."
    echo -e "                     Find koderne her: https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes"
    echo -e "  -q <soegestreng>   Specify the search string for file names."
    echo -e "  -f                 Force processing of files even if the audio language is not empty."
    echo -e "  -h                 Display this help message."
    echo -e "\nExamples:"
    echo -e "  ./und2lang.sh -s dan -q test"
    echo -e "  ./und2lang.sh -s eng -q \"James Bond\" -f"
    echo -e "\nThis script modifies the audio language code of MKV and MP4 files based on user input."
    exit 0
}
# Function to validate ISO 639-2 language codes
function validate_language_code() {
    local code="$1"
    local valid=false

    # List of valid ISO 639-2 codes (three-letter codes)
    local ISO_639_2_CODES=("en" "da" "no" "sv"
    "aar" "abk" "ace" "ach" "ada" "ady" "afa" "afh" "afr" "aka" "akk" "alb" "ale" "alg" "amh" "ang"
    "anp" "ara" "arc" "arg" "arm" "arn" "arp" "art" "arw" "asm" "ast" "ath" "aus" "ava" "ave" "aym"
    "aze" "bad" "bai" "bak" "bal" "bam" "ban" "bar" "bas" "beu" "bel" "bem" "ben" "ber" "bho" "bih"
    "bis" "bla" "bnt" "bos" "bra" "bre" "bri" "bug" "bul" "bur" "byn" "cad" "cai" "car" "cat" "cau"
    "ceb" "cel" "ces" "cha" "chb" "che" "chg" "chi" "chr" "chu" "chv" "chy" "cmc" "cni" "cop" "cor"
    "cos" "cpe" "cpf" "cpp" "cre" "crh" "crp" "csb" "cus" "cym" "dan" "dar" "day" "deu" "dgr" "din"
    "div" "doi" "dsb" "dua" "dum" "dyu" "dzo" "efi" "egy" "eka" "elx" "eng" "enm" "eo" "est" "ewe"
    "fan" "fao" "fij" "fin" "fiu" "fon" "fre" "frm" "fro" "frs" "fry" "ful" "geo" "ger" "gez" "gil"
    "gla" "gle" "glg" "glv" "gmh" "goh" "gon" "gor" "got" "grb" "gre" "grn" "guj" "gwi" "hai" "hak"
    "hat" "hau" "hax" "heb" "her" "hil" "him" "hin" "hmo" "hup" "hye" "ibo" "ice" "ijo" "iku" "ile"
    "ilo" "ina" "inc" "ind" "ine" "inh" "ipk" "ira" "iro" "isl" "ita" "jav" "jbo" "jpn" "jpr" "jrb"
    "jv" "kaa" "kab" "kac" "kal" "kam" "kan" "kar" "kas" "kat" "kau" "kaw" "kaz" "kbd" "kha" "khm"
    "khn" "kik" "kin" "kir" "kmb" "koy" "kpe" "kqu" "kri" "krl" "kru" "kua" "kum" "kur" "kut" "lad"
    "lah" "lam" "lao" "lat" "lav" "lez" "lim" "lin" "lit" "ljp" "lmo" "lo" "ltz" "lua" "lub" "lug"
    "lui" "lun" "luo" "lus" "mac" "mad" "mag" "mah" "mai" "mak" "mal" "man" "map" "mar" "mas" "mau"
    "mdf" "mdr" "men" "mic" "min" "mis" "mlg" "mlt" "mnc" "mni" "mno" "mo" "mon" "mos" "mri" "msa"
    "mua" "mul" "mun" "mus" "mwl" "mwr" "mya" "myn" "nap" "nau" "nav" "nbl" "nde" "ndo" "nds" "nep"
    "new" "nia" "nic" "niu" "nno" "nob" "nor" "nqo" "nrf" "nso" "nua" "nus" "nwi" "nya" "nyo" "oci"
    "oji" "ori" "orm" "osa" "oss" "ota" "oto" "paa" "pag" "pal" "pam" "pan" "pap" "par" "pas" "peo"
    "per" "pli" "pol" "por" "pra" "pro" "pus" "que" "raj" "rap" "rar" "rea" "ren" "ro" "rom" "ron"
    "roo" "rup" "rus" "sad" "sag" "sah" "sai" "sal" "sam" "san" "sas" "sat" "scn" "sco" "sel" "sem"
    "sga" "sgn" "sh" "shi" "shn" "sid" "sio" "sit" "sla" "slk" "slv" "sma" "sme" "smi" "smj" "sml"
    "smo" "sms" "sna" "snd" "snk" "sog" "som" "son" "sot" "spa" "sqi" "srd" "srn" "srp" "srr" "ssa"
    "ssw" "suk" "sun" "sux" "swa" "swe" "syc" "syr" "tah" "tai" "tam" "tat" "tel" "tem" "ter" "tet"
    "tgk" "tgl" "tha" "tib" "tig" "tir" "tiv" "tkl" "tlh" "tlw" "tly" "tmh" "tog" "ton" "tsi" "tsn"
    "tso" "tsi" "tum" "tun" "tur" "tut" "twi" "tyv" "udm" "uga" "uig" "uk" "umb" "und" "ur" "uz"
    "vai" "ven" "vie" "vot" "wak" "wal" "war" "was" "wel" "wen" "wln" "wol" "xal" "xho" "yao" "yap"
    "yid" "yor" "zap" "zbl" "zen" "zha" "zho" "znd" "zun" "zxx" "zxx")

    # Iterate through the list of valid codes and set the valid flag if the code matches
    for valid_code in "${ISO_639_2_CODES[@]}"; do
        if [[ "$code" == "$valid_code" ]]; then
            valid=true
            break
        fi
    done

    # Check if the code is valid or not
    if [[ "$valid" == false ]]; then
        echo -e "\e[1m\e[31mFEJL: Sprogkode \"$code\" er ikke gyldig. Indtast en gyldig ISO 639-2 kode.\e[0m\nFind koderne her: https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes\n"
        exit 1
    fi
}

echo -e "\n\e[1m\e[36m"
echo -e "###################################################"
echo -e "#                                                 #"
echo -e "#   \e[32mVelkommen til Hans' script til ændring af\e[36m     #"
echo -e "#         \e[32mMKV- og MP4-sprogkoder\e[36m                  #"
echo -e "#                                                 #"
echo -e "###################################################"
echo -e "\e[0m\n"

readonly REQUIREMENTS=("MP4Box" "mediainfo" "mkvpropedit")

# Check for installed CLI tools
# @param array names of required tools
function requires() {
    local arr=("$@")
    for i in "${arr[@]}"; do
        if ! command -v "$i" &>/dev/null; then
            echo -e "\e[1m\e[31mFEJL: Mangler afhængigheder (${REQUIREMENTS[@]}).\n\"$i\" kunne ikke findes.\nInstallér det og prøv igen.\e[0m\n"
            exit 1
        fi
    done
}

requires "${REQUIREMENTS[@]}"

# Parsing command-line options using getopts
while getopts ":s:q:fh" opt; do
  case $opt in
    s) sprogkode="$OPTARG"
    ;;
    q) soegestreng="$OPTARG"
    ;;
    f) force_processing=true
    ;;
    h) display_help
    ;;
    \?) echo -e "Ugyldig mulighed: -$OPTARG" >&2
        exit 1
    ;;
    :) echo -e "Option -$OPTARG kræver et argument." >&2
       exit 1
    ;;
  esac
done

# Prompt for sprogkode if not provided via flag
if [ -z "$sprogkode" ]; then
    read -p 'Indtast sprogkode (ISO 639-2, f.eks. "dan" for dansk): ' sprogkode
fi

# Validate the sprogkode against the ISO 639-2 codes
validate_language_code "$sprogkode"

# Prompt for soegestreng if not provided via flag
if [ -z "$soegestreng" ]; then
    read -p 'Indtast søgestreng: ' soegestreng
fi

echo -e "\nSøger efter '\e[1m*$soegestreng*.(mkv|mp4)\e[0m' og indstiller lydsproget til '\e[1m$sprogkode\e[0m'\n\n--------------\n"

# Find and process files
find . \( -iname "*$soegestreng*.mkv" -o -iname "*$soegestreng*.mp4" \) -print0 | {
    while IFS= read -r -d $'\0' file; do
        glsprog=$(mediainfo --Output="Audio;%Language/String1%" "$file")

        # Check if glsprog is empty or if force processing is enabled
        if [[ -z "$glsprog" || "$force_processing" == true ]]; then
            counter=$((counter+1))
            filtype=${file##*.}
            echo -e "$counter:\nHar fundet filen: \"\e[3m$file\e[0m\""
            echo -e "\n${filtype^^}-filen har sprogkoden: \e[1m$glsprog\e[0m"

            if [[ "${filtype,,}" == "mp4" ]]; then
                echo -e "Starter MP4Box"
                MP4Box -v "${file%.*}.mp4" -lang audio=$sprogkode
            elif [[ "${filtype,,}" == "mkv" ]]; then
                echo -e "Starter MKVToolNix"
                mkvpropedit -v "${file%.*}.mkv" --edit track:a1 --set language=$sprogkode
            fi

            # Display new language
            echo -e "\nFilen er nu indstillet til: \e[1m"
            mediainfo --Output="Audio;%Language/String1%" "$file"
            echo -e "\e[0m\n--------------\n"
        fi
    done

    echo 'Scriptet er nået til vejs ende'

    if [[ $counter -eq 1 ]]; then
        echo -e "$counter fil blev behandlet"
    else
        echo -e "$counter filer blev behandlet"
    fi
}

# How to use the flags:
#
#     Without flags (prompted):
#
#     The script will prompt for sprogkode and soegestreng if they are not provided via flags.
#
#     With flags:
#
#     bash
#
# ./und2lang.sh -s da -q test -f -h
#
#     -s: dan (Danish ISO 639-2 language code)
#     -q: test (search string)
#     -f: Force processing files even if glsprog is not empty
#     -h: Display this help message
