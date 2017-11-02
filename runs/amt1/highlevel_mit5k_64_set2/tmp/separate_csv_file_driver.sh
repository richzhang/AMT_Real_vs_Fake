# ~~~ 10/31 done ~~~
# N_ASSIGN=2
# SET_NAME=highlevel_mit5k_64_set2
# python ./separate_csv_file.py --turk_dir ${TURK_ROOT}/${SET_NAME} --res_filename ./results0.csv --turk_filename ./${SET_NAME}.csv --N_assign ${N_ASSIGN}

# N_ASSIGN=1
# python ./separate_csv_file.py --turk_dir ${TURK_ROOT}/${SET_NAME} --res_filename ./results1.csv --turk_filename ./${SET_NAME}_rem3.csv --N_assign ${N_ASSIGN}

# N_ASSIGN=1
# python ./separate_csv_file.py --turk_dir ${TURK_ROOT}/${SET_NAME} --res_filename ./results2.csv --turk_filename ./${SET_NAME}_rem3_rem2.csv --N_assign ${N_ASSIGN}

# N_ASSIGN=2
# python ./separate_csv_file.py --turk_dir ${TURK_ROOT}/${SET_NAME} --res_filename results_total.csv --turk_filename ./${SET_NAME}.csv --N_assign ${N_ASSIGN}

# Fusion
python ./fuse_csv_files.py --file_dir ../AMT_Real_vs_Fake/runs/amt1/highlevel_mit5k_64_set2/ --filenames results0_pass77.csv results1_pass1.csv results2_pass2.csv --filename_out results_total_fused.csv
