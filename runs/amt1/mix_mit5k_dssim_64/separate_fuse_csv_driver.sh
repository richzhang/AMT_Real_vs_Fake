TURK_ROOT=../AMT_Real_vs_Fake/runs/amt1/
SET_NAME=mix_mit5k_dssim_64
N_ASSIGN=2
# RND_NUMBER=1

# echo ${SET_NAME}
python ./separate_csv_file.py --turk_dir ${TURK_ROOT}/${SET_NAME} --res_filename ./results0f.csv --turk_filename ./${SET_NAME}.csv --N_assign ${N_ASSIGN}

# Fuse
# python ./fuse_csv_files.py --file_dir ${TURK_ROOT}/${SET_NAME} --filenames ./results0_pass.csv ./results1.csv --filename_out results1f.csv

# Round 2
# python ./separate_csv_file.py --turk_dir ${TURK_ROOT}/${SET_NAME} --res_filename ./results1f.csv --turk_filename ./${SET_NAME}.csv --N_assign ${N_ASSIGN}
