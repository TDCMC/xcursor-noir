#!/bin/bash

ALLSCR="all_scroll all-scroll"
 L_PTR="left_ptr arrow default top_left_arrow"
 CROSS="cross diamond-cross cross-reverse crosshair"
UP_ARR="up_arrow center_ptr sb_up_arrow centre_ptr"
 WAIT="wait watch progress"
 IBEAM="ibeam xterm text"
 FLEUR="fleur move size_all 4498f0e0c1937ffe01fd06f973665830 9081237383d90e509aa00f00170e968f fcf21c00b30f7e3f83fe0dfd12e71cff"
 HAND2="pointing_hand pointer hand hand2 e29285e634086352946a0e7090d73106 9d800788f1b08800ae810202380a0822"
SZ_VER="size_ver sb_v_double_arrow v_double_arrow n-resize s-resize col-resize top_side bottom_side base_arrow_up base_arrow_down based_arrow_down based_arrow_up 00008160000006810000408080010102"
SZ_HOR="size_hor sb_h_double_arrow h_double_arrow e-resize w-resize row-resize right_side left_side 028006030e0e7ebffc7f7070c0600140"
SZ_BDG="size_bdiag fd_double_arrow bottom_left_corner top_right_corner fcf1c3c7cd4491d801f1e1c78f100000"
SZ_FDG="size_fdiag bd_double_arrow bottom_right_corner top_left_corner c7088f0f3e6c8088236ef8e1e3e70000"
WHATST="whats_this left_ptr_help help question_arrow dnd-ask d9ce0ab605698f320427677b458ad60b 5c6cd98b3f3ebcb1f9c7f1c204630408"
SPLT_H="split_h 14fef782d02440884392942c11205230 size_hor"
SPLT_V="split_v 2870a09082c103050810ffdffffe0204 size_ver"
FORBID="forbidden circle dnd-no-drop no-drop not-allowed 03b6e0fcb3499374a867c041f52298f0"
LPWTCH="left_ptr_watch half-busy 3ecb610c1bf2410f44200f48c40d3599 00000000000000020006000e7e9ffc3f 08e8e1c95fe2fc01f976f1e063a24ccd"
O_HAND="grab hand1 openhand 9141b49c8149039304290b508d208c40"
C_HAND="closedhand dnd-none grabbing 05e88622050804100c20044008402080"
 ALIAS="dnd-link link alias 3085a0e285430894940527032f8b26df 640fb0e74195791501fd1ed57b41487f a2a266d0498c3104214a47bd64ab0fc8"
  COPY="dnd-copy copy 1081e37283d90000800003c07f3ef6bf 6407b0e94181790501fd1e167b474872 b66166c04f8c3109214a4fbd64a50fc8"
XCURSR="x-cursor X_cursor"
WAYCUR="wayland-cursor wayland_cursor"

SHAPES="ALLSCR L_PTR CROSS UP_ARR WAIT IBEAM FLEUR HAND2 SZ_VER SZ_HOR SZ_BDG SZ_FDG WHATST SPLT_H SPLT_V FORBID LPWTCH O_HAND C_HAND ALIAS COPY XCURSR WAYCUR"

fix_false_group() {
    if [ -L "$1" ]; then
        rm "$1" # symlink, just get rid of it and have the script restore it properly
    elif [ -e "$1" ]; then
        # file exists and is a real file. remove all false symlinks to it
        for ALTERNATIVE in $2; do
            if [ -L "$ALTERNATIVE" ]; then
                TARGET="$(realpath $ALTERNATIVE)"
                if [ "$(basename $TARGET)" = "$1" ]; then
                    rm "$ALTERNATIVE"
                fi
            fi
        done
    fi
}

fix_cursors()  {
    # those two have been swapped in KDE and falsely linked by v0.1 of this script
    # ensure they do NOT point into the wrong group (2nd parameter)
    fix_false_group "fcf1c3c7cd4491d801f1e1c78f100000" "$SZ_FDG"
    fix_false_group "c7088f0f3e6c8088236ef8e1e3e70000" "$SZ_BDG"
    if [ "$1" = "override" ]; then
        for name in *; do
            if [ -L "$name" ]; then
                rm "$name"
            fi
        done
    fi
    for GROUP in $SHAPES; do
        eval SHAPE='$'$GROUP
        echo $SHAPE
        unset PRESENT
        for ALTERNATIVE in $SHAPE; do
            if [ -e $ALTERNATIVE ]; then
                PRESENT=$ALTERNATIVE
                break
            fi
        done
        if [ -z $PRESENT ]; then
            echo "*** WARNING *** No usable cursor for $GROUP"
            continue
        else
            echo $PRESENT
        fi
        for ALTERNATIVE in $SHAPE; do
            if [ ! -e $ALTERNATIVE ]; then
                ln -s $PRESENT $ALTERNATIVE
            fi
        done
    done
}

fix_cursors $1
