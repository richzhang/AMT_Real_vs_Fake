TURK_ROOT=../AMT_Real_vs_Fake/runs/amt1/
N_ASSIGN=2
# SET_NAME=mix_mit5k_L2_64
# SET_NAME=mix_mit5k_dssim_64
# SET_NAME=mix_mit5k_vgg_64
SET_NAME=${1}
# RND_NUMBER=1

# echo ${SET_NAME}
python ./separate_csv_file.py --turk_dir ${TURK_ROOT}/${SET_NAME} --res_filename ./results0f.csv --turk_filename ./${SET_NAME}.csv --N_assign ${N_ASSIGN}

# Fuse 0f+1 ==> 1f
python ./fuse_csv_files.py --file_dir ${TURK_ROOT}/${SET_NAME} --filenames ./results0f_pass.csv ./results1.csv --filename_out results1f.csv

# Process 1f
python ./separate_csv_file.py --turk_dir ${TURK_ROOT}/${SET_NAME} --res_filename ./results1f.csv --turk_filename ./${SET_NAME}.csv --N_assign ${N_ASSIGN}
