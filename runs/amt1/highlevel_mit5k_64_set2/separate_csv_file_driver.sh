TURK_ROOT=../AMT_Real_vs_Fake/runs/amt1/
N_ASSIGN=2
SET_NAME=highlevel_mit5k_64_set2
# RND_NUMBER=1

# Process preliminary file
python ./separate_csv_file.py --turk_dir ${TURK_ROOT}/${SET_NAME} --res_filename ./results0f.csv --turk_filename ./${SET_NAME}.csv --N_assign ${N_ASSIGN}

# Process files
for CUR in 1 2
do
PREV=$(expr ${CUR} - 1)
echo '('${PREV}','${CUR}')'
python ./fuse_csv_files.py --file_dir ${TURK_ROOT}/${SET_NAME} --filenames ./results${PREV}f_pass.csv ./results${CUR}.csv --filename_out results${CUR}f.csv

# Process 1f
python ./separate_csv_file.py --turk_dir ${TURK_ROOT}/${SET_NAME} --res_filename ./results${CUR}f.csv --turk_filename ./${SET_NAME}.csv --N_assign ${N_ASSIGN}
done