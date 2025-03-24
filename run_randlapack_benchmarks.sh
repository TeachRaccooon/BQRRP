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
fi

# Attempt to grab the CPU name
CPU_NAME=$(lscpu | grep "Model name" | awk -F ': ' '{print $2}' | tr -d '[:punct:]' | tr ' ' '_' | sed 's/^_*//g')
# Check if the CPU name was retrieved successfully
if [[ -z "$CPU_NAME" ]]; then
    echo "Failed to retrieve CPU name. Naming it after today's date."
    CPU_NAME=$(date +"%Y-%m-%d")
fi
CPU_DIR="$BENCHMARK_OUTPUT_DIR/$CPU_NAME"

# Create the directory named after the current CPU 
if [[ ! -d "$$CPU_DIR" ]]; then
    mkdir -p "$CPU_DIR"
    echo "Directory created at: $CPU_DIR"
fi
# Create the directories for specific BQRRP benchmarks
if [[ ! -d "$CPU_DIR/HQRRP_plot_remake" ]]; then
    mkdir -p "$CPU_DIR/HQRRP_plot_remake"
    echo "Directory created at: $CPU_DIR/HQRRP_plot_remake"
fi
if [[ ! -d "$CPU_DIR/BQRRP_subroutines_speed" ]]; then
    mkdir -p "$CPU_DIR/BQRRP_subroutines_speed"
    echo "Directory created at: $CPU_DIR/BQRRP_subroutines_speed"
fi
if [[ ! -d "$CPU_DIR/BQRRP_runtime_breakdown" ]]; then
    mkdir -p "$CPU_DIR/BQRRP_runtime_breakdown"
    echo "Directory created at: $CPU_DIR/BQRRP_runtime_breakdown"
fi
if [[ ! -d "$CPU_DIR/BQRRP_speed_comparisons_block_size" ]]; then
    mkdir -p "$CPU_DIR/BQRRP_speed_comparisons_block_size"
    echo "Directory created at: $CPU_DIR/BQRRP_speed_comparisons_block_size"
fi
if [[ ! -d "$CPU_DIR/BQRRP_speed_comparisons_mat_size" ]]; then
    mkdir -p "$CPU_DIR/BQRRP_speed_comparisons_mat_size"
    echo "Directory created at: $CPU_DIR/BQRRP_speed_comparisons_mat_size"
fi
if [[ ! -d "$CPU_DIR/HQRRP_speed_comparisons_block_size" ]]; then
    mkdir -p "$CPU_DIR/HQRRP_speed_comparisons_block_size"
    echo "Directory created at: $CPU_DIR/HQRRP_speed_comparisons_block_size"
fi
if [[ ! -d "$CPU_DIR/HQRRP_runtime_breakdown" ]]; then
    mkdir -p "$CPU_DIR/HQRRP_runtime_breakdown"
    echo "Directory created at: $CPU_DIR/HQRRP_runtime_breakdown"
fi
if [[ ! -d "$CPU_DIR/BQRRP_speed_comparisons_block_size_small" ]]; then
    mkdir -p "$CPU_DIR/BQRRP_speed_comparisons_block_size_small"
    echo "Directory created at: $CPU_DIR/BQRRP_speed_comparisons_block_size_small"
fi
if [[ ! -d "$CPU_DIR/BQRRP_speed_comparisons_mat_size_rectangular" ]]; then
    mkdir -p "$CPU_DIR/BQRRP_speed_comparisons_mat_size_rectangular"
    echo "Directory created at: $CPU_DIR/BQRRP_speed_comparisons_mat_size_rectangular"
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
    MAX_THREADS=$((2 * CPU_SOCKETS * $(nproc --all)))
    
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
    
    # Make a shortcut variable
    EXECUTION_DIR=$RANDNLA_PROJECT_DIR/build/benchmark-build

    # Get the benchmark commencement date
    DATETIME=$(date "+%Y-%m-%d-%H:%M:%S")

    # PERFORMING BENCHMARK RUNS
    # HQRRP plot remake benchmarks
    for ITEM in "${THREADS_LIST[@]}"; do
        echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM EXECUTION_DIR/BQRRP_speed_comparisons_mat_size CPU_DIR/HQRRP_plot_remake/$DATETIME hqrrp_const 1 1 1 1000;"
        eval "$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM $EXECUTION_DIR/BQRRP_speed_comparisons_mat_size $CPU_DIR/HQRRP_plot_remake/$DATETIME hqrrp_const 1 1 1 1000;"
    done
    echo -e "HQRRP plot remake benchmarks complete\n"

    # BQRRP subroutines speed
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_subroutines_speed CPU_DIR/BQRRP_subroutines_speed/$DATETIME 1 1024 256;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_subroutines_speed $CPU_DIR/BQRRP_subroutines_speed/$DATETIME 1 1024 256;"

    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_subroutines_speed CPU_DIR/BQRRP_subroutines_speed/$DATETIME 1 1000 250;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_subroutines_speed $CPU_DIR/BQRRP_subroutines_speed/$DATETIME 1 1000 250;"
    echo -e "BQRRP subroutines speed complete\n"

    # BQRRP runtime breakdown
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_runtime_breakdown CPU_DIR/BQRRP_runtime_breakdown/$DATETIME cholqr 1 1024 1024 256;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_runtime_breakdown $CPU_DIR/BQRRP_runtime_breakdown/$DATETIME cholqr 1 1024 1024 256;"
    
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_runtime_breakdown CPU_DIR/BQRRP_runtime_breakdown/$DATETIME geqrf  1 1024 1024 256;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_runtime_breakdown $CPU_DIR/BQRRP_runtime_breakdown/$DATETIME geqrf  1 1024 1024 256;"
    
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_runtime_breakdown CPU_DIR/BQRRP_runtime_breakdown/$DATETIME cholqr 1 1000 1000 250;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_runtime_breakdown $CPU_DIR/BQRRP_runtime_breakdown/$DATETIME cholqr 1 1000 1000 250;"
    
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_runtime_breakdown CPU_DIR/BQRRP_runtime_breakdown/$DATETIME geqrf  1 1000 1000 250;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_runtime_breakdown $CPU_DIR/BQRRP_runtime_breakdown/$DATETIME geqrf  1 1000 1000 250;"
    echo -e "BQRRP runtime breakdown complete\n"

    # BQRRP performance varying block size
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_speed_comparisons_block_size CPU_DIR/BQRRP_speed_comparisons_block_size/$DATETIME default 1 1024 1024 256;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_speed_comparisons_block_size $CPU_DIR/BQRRP_speed_comparisons_block_size/$DATETIME default 1 1024 1024 256;"

    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_speed_comparisons_block_size CPU_DIR/BQRRP_speed_comparisons_block_size/$DATETIME default 1 1000 1000 250;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_speed_comparisons_block_size $CPU_DIR/BQRRP_speed_comparisons_block_size/$DATETIME default 1 1000 1000 250;"
    echo -e "BQRRP performance varying block size complete\n"

    # BQRRP performance varying mat size
    for ITEM in "${THREADS_LIST[@]}"; do
        echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM EXECUTION_DIR/BQRRP_speed_comparisons_mat_size CPU_DIR/BQRRP_speed_comparisons_mat_size/$DATETIME default 1 1 32 1000;"
        eval "$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM $EXECUTION_DIR/BQRRP_speed_comparisons_mat_size $CPU_DIR/BQRRP_speed_comparisons_mat_size/$DATETIME default 1 1 32 1000;"
    done
    echo -e "BQRRP performance varying mat size complete\n"

    # HQRRP performance varying block size
    for ITEM in "${THREADS_LIST[@]}"; do
        echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM EXECUTION_DIR/BQRRP_speed_comparisons_block_size CPU_DIR/HQRRP_speed_comparisons_block_size/$DATETIME hqrrp 1 1000 1000 5;"
        eval "$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM $EXECUTION_DIR/BQRRP_speed_comparisons_block_size $CPU_DIR/HQRRP_speed_comparisons_block_size/$DATETIME hqrrp 1 1000 1000 5;"
    done
    echo -e "HQRRP performance varying block size complete\n"

    # HQRRP runtime breakdown
    for ITEM in "${THREADS_LIST[@]}"; do
        echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM EXECUTION_DIR/HQRRP_runtime_breakdown CPU_DIR/HQRRP_runtime_breakdown/$DATETIME 1 1000 1000 5;"
        eval "$NUMACTL_VAR env OMP_NUM_THREADS=$ITEM $EXECUTION_DIR/HQRRP_runtime_breakdown $CPU_DIR/HQRRP_runtime_breakdown/$DATETIME 1 1000 1000 5;"
    done
    echo -e "HQRRP runtime breakdown complete\n"

    # BQRRP performance varying block size small
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_speed_comparisons_block_size CPU_DIR/BQRRP_speed_comparisons_block_size_small/$DATETIME default 1 1000 1000 5;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_speed_comparisons_block_size $CPU_DIR/BQRRP_speed_comparisons_block_size_small/$DATETIME default 1 1000 1000 5;"
    echo -e "BQRRP performance varying block size small complete\n"

    # BQRRP performance varying mat size rectangular: tall and wide
    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_speed_comparisons_mat_size CPU_DIR/BQRRP_speed_comparisons_mat_size_rectangular/$DATETIME default_hqrrp_const 1 2   32 1000;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_speed_comparisons_mat_size $CPU_DIR/BQRRP_speed_comparisons_mat_size_rectangular/$DATETIME default_hqrrp_const 1 2   32 1000;"

    echo -e "\n$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS EXECUTION_DIR/BQRRP_speed_comparisons_mat_size CPU_DIR/BQRRP_speed_comparisons_mat_size_rectangular/$DATETIME default_hqrrp_const 1 0.5 32 1000;"
    eval "$NUMACTL_VAR env OMP_NUM_THREADS=$MAX_THREADS $EXECUTION_DIR/BQRRP_speed_comparisons_mat_size $CPU_DIR/BQRRP_speed_comparisons_mat_size_rectangular/$DATETIME default_hqrrp_const 1 0.5 32 1000;"
    echo -e "BQRRP performance varying mat size rectangular: tall and wide complete\n"
fi

# Source from bash and spawn a new shell so that the variable change takes place
bash -c "source ~/.bashrc && exec bash"
