# Check if RANDNLA_PROJECT_DIR is not set or empty
if [[ -z "${RANDNLA_PROJECT_DIR}" ]]; then
    echo "Error: RANDNLA_PROJECT_DIR is not set or empty."
    echo "This varibale is set during the initial execution of /RandLAPACK/install.sh."
    echo "Consider installing RandLAPACK via /RandLAPACK/install.sh or setting the RANDNLA_PROJECT_DIR variable manually (not recommended)."
    exit 1
fi

# Create the benchmark output directory if it does not exist
if [[ ! -d "$BENCHMARK_OUTPUT_DIR" ]]; then
    mkdir -p "$RANDNLA_PROJECT_DIR/build/benchmark-build/benchmark-output"
    echo "Directory created at: $RANDNLA_PROJECT_DIR/build/benchmark-build/benchmark-output"
    BENCHMARK_OUTPUT_DIR="$RANDNLA_PROJECT_DIR/build/benchmark-build/benchmark-output"

    # We need to add the BENCHMARK_OUTPUT_DIR variable to bashrc in order to avoid potentially 
    # re-writing all of the previsouly-gatherred benchmarking data.
    echo "Adding variable $BENCHMARK_OUTPUT_DIR to ~/.bashrc."
    echo "#Added via run_randlapack_benhcmarks.sh" >> ~/.bashrc
    echo "export BENCHMARK_OUTPUT_DIR=\"$RANDNLA_PROJECT_DIR/build/benchmark-build/benchmark-output\"" >> ~/.bashrc
    # Reload bashrc to make the new variable visible
    #bash -c "source setvars.sh --force && source ~/.bashrc && exec bash"
    bash -c "source ~/.bashrc && exec bash"
fi

# Attempt to grab the CPU name
CPU_NAME=$(lscpu | grep "Model name" | awk -F ': ' '{print $2}' | tr -d '[:punct:]' | tr ' ' '_' | sed 's/^_*//g')
# Check if the CPU name was retrieved successfully
if [[ -z "$CPU_NAME" ]]; then
    echo "Failed to retrieve CPU name. Naming it after today's date."
    CPU_NAME=$(date +"%Y-%m-%d")
fi
CPU_NAME="$BENCHMARK_OUTPUT_DIR/$CPU_NAME"

# Create the directory named after the current CPU 
if [[ ! -d "$$CPU_NAME" ]]; then
    mkdir -p "$CPU_NAME"
    echo "Directory created at: $CPU_NAME"
fi
# Create the directories for specific BQRRP benchmarks
if [[ ! -d "$CPU_NAME/HQRRP_plot_remake" ]]; then
    mkdir -p "$CPU_NAME/HQRRP_plot_remake"
    echo "Directory created at: $CPU_NAME/HQRRP_plot_remake"
fi
if [[ ! -d "$CPU_NAME/BQRRP_subroutines_speed" ]]; then
    mkdir -p "$CPU_NAME/BQRRP_subroutines_speed"
    echo "Directory created at: $CPU_NAME/BQRRP_subroutines_speed"
fi
if [[ ! -d "$CPU_NAME/BQRRRP_runtime_breakdown" ]]; then
    mkdir -p "$CPU_NAME/BQRRRP_runtime_breakdown"
    echo "Directory created at: $CPU_NAME/BQRRRP_runtime_breakdown"
fi
if [[ ! -d "$CPU_NAME/BQRRP_speed_comparisons_block_size" ]]; then
    mkdir -p "$CPU_NAME/BQRRP_speed_comparisons_block_size"
    echo "Directory created at: $CPU_NAME/BQRRP_speed_comparisons_block_size"
fi
if [[ ! -d "$CPU_NAME/BQRRP_speed_comparisons_mat_size" ]]; then
    mkdir -p "$CPU_NAME/BQRRP_speed_comparisons_mat_size"
    echo "Directory created at: $CPU_NAME/BQRRP_speed_comparisons_mat_size"
fi
if [[ ! -d "$CPU_NAME/HQRRP_speed_comparisons_block_size" ]]; then
    mkdir -p "$CPU_NAME/HQRRP_speed_comparisons_block_size"
    echo "Directory created at: $CPU_NAME/HQRRP_speed_comparisons_block_size"
fi
if [[ ! -d "$CPU_NAME/HQRRP_runtime_breakdown" ]]; then
    mkdir -p "$CPU_NAME/HQRRP_runtime_breakdown"
    echo "Directory created at: $CPU_NAME/HQRRP_runtime_breakdown"
fi
if [[ ! -d "$CPU_NAME/BQRRP_speed_comparisons_block_size_small" ]]; then
    mkdir -p "$CPU_NAME/BQRRP_speed_comparisons_block_size_small"
    echo "Directory created at: $CPU_NAME/BQRRP_speed_comparisons_block_size_small"
fi
if [[ ! -d "$CPU_NAME/BQRRP_speed_comparisons_mat_size_rectangular" ]]; then
    mkdir -p "$CPU_NAME/BQRRP_speed_comparisons_mat_size_rectangular"
    echo "Directory created at: $CPU_NAME/BQRRP_speed_comparisons_mat_size_rectangular"
fi

# Ask the user if they want to continue or terminate the script
read -p "Directory structure preparation complete. Commence BQRRP CPU benchmarking? (y/n): " user_input
if [[ "$user_input" != "y" && "$user_input" != "Y" ]]; then
    echo "Skipping CPU benchmarks."
    exit 1
else
    # PRELIMINARY INFO GATHERING BEFORE RUNNING BENCHMAKRS
    # Set the list of the numbers of threads that will be used in our CPU benchmarks
    # Check the number of CPU sockets
    CPU_SOCKETS=$(grep -c 'physical id' /proc/cpuinfo)
    # Determine the maximum number of OpenMP threads that can be used on a given system
    MAX_THREADS=$((2*CPU_SOCKETS*(nproc --all)))
    
    THREADS_LIST=(1)
    # Exceptional case used for the AMD system with exceptionally large core count
    if [[ $MAX_THREADS -eq 448 ]]; then
        THREADS_LIST=("1" "16" "32" "64" "128" "448")
    else 
        LAST_THREAD_NUM=16
        # Add numbers to the list, doubling each time
        while (( LAST_THREAD_NUM <= MAX_THREADS )); do
            THREADS_LIST+=("$LAST_THREAD_NUM")
            LAST_THREAD_NUM=$((2 * LAST_THREAD_NUM))
        done
    fi
    
    NUMACTL_VAR=""
    # Check if we can/should use numactl
    if [[ $CPU_SOCKETS -gt 1 ]]; then 
        # Check if numactl is available
        if command -v numactl &> /dev/null; then
            NUMACTL_VAR = "numactl --interleave=all"
            echo "numactl is installed."
        else
            echo "numactl is not installed"
            read -p "Without numactl, algorithms performance may vary greatly from that reported in the BQRRP paper. Continue anyway? (y/n): " user_input
            if [[ "$user_input" != "y" && "$user_input" != "Y" ]]; then
                echo "Skipping CPU benchmarks. Please install numactl."
            exit 1
            fi
        fi
    fi

    # Get the benchmark commencement date
    DATETIME=$(date "+%Y-%m-%d %H:%M:%S")

    # PERFORMING BENCHMARK RUNS
    # HQRRP plot remake benchmarks
    for ITEM in "${THREADS_LIST[@]}"; do
        echo "$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM ./BQRRP_speed_comparisons_mat_size $CPU_NAME/HQRRP_plot_remake/$DATETIME hqrrp_const 20 1 1 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000;"
    done

    # BQRRP subroutines speed
    echo "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS ./BQRRP_subroutines_speed $CPU_NAME/BQRRP_subroutines_speed/$DATETIME 3 65536 256 512 1024 2048 4096 8192"
    echo "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS ./BQRRP_subroutines_speed $CPU_NAME/BQRRP_subroutines_speed/$DATETIME 3 64000 250 500 1000 2000 4000 8000;"

    # BQRRP runtime breakdown
    echo "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS ./BQRRP_runtime_breakdown $CPU_NAME/BQRRRP_runtime_breakdown/$DATETIME cholqr 3 65536 65536 256 512 1024 2048 4096 8192;"
    echo "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS ./BQRRP_runtime_breakdown $CPU_NAME/BQRRRP_runtime_breakdown/$DATETIME geqrf  3 65536 65536 256 512 1024 2048 4096 8192;"
    echo "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS ./BQRRP_runtime_breakdown $CPU_NAME/BQRRRP_runtime_breakdown/$DATETIME cholqr 3 64000 64000 250 500 1000 2000 4000 8000;"
    echo "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS ./BQRRP_runtime_breakdown $CPU_NAME/BQRRRP_runtime_breakdown/$DATETIME geqrf  3 64000 64000 250 500 1000 2000 4000 8000;"

    # BQRRP performance varying block size
    echo "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS ./BQRRP_speed_comparisons_block_size $CPU_NAME/BQRRP_speed_comparisons_block_size/$DATETIME default 3 65536 65536 256 512 1024 2048 4096 8192;"
    echo "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS ./BQRRP_speed_comparisons_block_size $CPU_NAME/BQRRP_speed_comparisons_block_size/$DATETIME default 3 64000 64000 250 500 1000 2000 4000 8000;"

    # BQRRP performance varying mat size
    for ITEM in "${THREADS_LIST[@]}"; do
        echo "$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM ./BQRRP_speed_comparisons_mat_size $CPU_NAME/BQRRP_speed_comparisons_mat_size/$DATETIME default 3 1 32 0 8000 16000 32000;"
    done

    # HQRRP performance varying block size
    for ITEM in "${THREADS_LIST[@]}"; do
        echo "$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM ./BQRRP_speed_comparisons_block_size $CPU_NAME/HQRRP_speed_comparisons_block_size/$DATETIME hqrrp 3 32000 32000 5 10 25 50 125 250 500 1000 2000 4000 8000;"
    done

    # HQRRP runtime breakdown
    for ITEM in "${THREADS_LIST[@]}"; do
        echo "$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM ./HQRRP_runtime_breakdown $CPU_NAME/HQRRP_runtime_breakdown/$DATETIME 3 32000 32000 5 10 25 50 125 250 500 1000 2000 4000 8000;"
    done

    # BQRRP performance varying block size small
    echo "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS ./BQRRP_speed_comparisons_block_size $CPU_NAME/BQRRP_speed_comparisons_block_size_small/$DATETIME default 3 1000 1000 5 10 25 50 125 250 500 1000;"
    echo "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS ./BQRRP_speed_comparisons_block_size $CPU_NAME/BQRRP_speed_comparisons_block_size_small/$DATETIME default 3 2000 2000 5 10 25 50 125 250 500 1000 2000;"
    echo "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS ./BQRRP_speed_comparisons_block_size $CPU_NAME/BQRRP_speed_comparisons_block_size_small/$DATETIME default 3 4000 4000 5 10 25 50 125 250 500 1000 2000 4000;"

    # BQRRP performance varying mat size rectangular: tall and wide
    echo "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS ./BQRRP_speed_comparisons_mat_size $CPU_NAME/BQRRP_speed_comparisons_mat_size_rectangular/$DATETIME default_hqrrp_const 3 2   32 0 8000 16000 32000 64000;"
    echo "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS ./BQRRP_speed_comparisons_mat_size $CPU_NAME/BQRRP_speed_comparisons_mat_size_rectangular/$DATETIME default_hqrrp_const 3 0.5 32 0 8000 16000 32000 64000;"
fi
