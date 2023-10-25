import pandas as pd

mode = "t" #t - throat, f - freestream

if mode == "t":
    df = pd.read_csv("throat-wall-ss.dat", 
                    sep="\s+", 
                    skiprows=1, 
                    names=['pos.x', 'pos.y', 'pos.z', 'volume', 'rho', 'vel.x', 'vel.y', 'vel.z', 'p', 'a', 'mu', 'k', 'mu_t', 'k_t', 'S', 'massf[0]-air', 'u', 'T', 'M_local', 'total_p'])

    arithm_ave_p_throat = df["total_p"].mean()
    print('tot_p_throat_ave','{:e}'.format(arithm_ave_p_throat))

elif mode == "f":
    df = pd.read_csv("inlet-freestream-ss.dat", 
                    sep="\s+", 
                    skiprows=1, 
                    names=['pos.x', 'pos.y', 'pos.z', 'volume', 'rho', 'vel.x', 'vel.y', 'vel.z', 'p', 'a', 'mu', 'k', 'mu_t', 'k_t', 'S', 'massf[0]-air', 'u', 'T', 'M_local', 'total_p'])
    arithm_ave_freestream_press = df["total_p"].mean()
    print('total_p_freestream_ave','{:e}'.format(arithm_ave_freestream_press))