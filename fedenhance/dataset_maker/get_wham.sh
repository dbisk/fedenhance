#!/bin/bash
# from https://github.com/etzinis/sudo_rm_rf/blob/master/sudo_rm_rf/utils/generate_data.sh

# run this with get_wham.sh /mnt/data/wsj0-mix/wsj0 /mnt/data/wham
# first dir is the wsj dir and the second is the outpur dir for wham

echo "Preparing WHAM data..."
# Copied from the wham generation script:
# https://github.com/mpariente/asteroid/blob/master/egs/wham/TwoStep/local/prepare_data.sh
wav_dir=$1
out_dir=$2
python_path=python

. utils/parse_options.sh

## Download WHAM noises
mkdir -p $out_dir
echo "Download WHAM noises into $out_dir"
# If downloading stalls for more than 20s, relaunch from previous state.
wget -c --tries=0 --read-timeout=20 https://storage.googleapis.com/whisper-public/wham_noise.zip -P $out_dir
unzip $out_dir/wham_noise.zip -d $out_dir

echo "Download WHAM scripts into $out_dir"
wget https://storage.googleapis.com/whisper-public/wham_scripts.tar.gz -P $out_dir
mkdir -p $out_dir/wham_scripts
tar -xzvf $out_dir/wham_scripts.tar.gz -C $out_dir/wham_scripts
mv $out_dir/wham_scripts.tar.gz $out_dir/wham_scripts

wait

echo "Run python scripts to create the WHAM mixtures"
# Requires : Numpy, Scipy, Pandas, and Pysoundfile
cd $out_dir/wham_scripts/wham_scripts
$python_path create_wham_from_scratch.py \
	--wsj0-root $wav_dir \
	--wham-noise-root $out_dir/wham_noise\
	--output-dir $out_dir
cd -

