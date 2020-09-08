
function get_n_proc {
    N=$(nproc)
    if (( N >= 4));then
        N=$((N/2))
    fi
    echo $N
}

function m_make {
    NPROC=$(get_n_proc)
    make -j${NPROC} $@
}

