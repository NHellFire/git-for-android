# Git for Android

This will build git intended for installation in /data/local/git/



### Build steps

1. Clone repo  
   `$ git clone --recursive https://github.com/NHellFire/git-for-android`
   

2. Change directory  
   `$ cd git-for-android`
   
3. Apply required patches  
  `$ patch -p1 -i ../disable-librt.patch`

4. Edit config  
   ```bash
   $ cp config.sh.sample config.sh
   $ nano config.sh
   ```

5. Build  
   `./build.sh`
   
   
6. Result is in `install_dir/`
