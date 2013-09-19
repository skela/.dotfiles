# Utility Class to create resource recipes for image resources in iOS Projects.
#
# svg2png - Depends on Inkscape
# xcf2png - Depends on the command convert (imageMagick)

import sys
import os

class R:
    
    path_inkscape="/Applications/Inkscape.app/Contents/Resources/bin/inkscape"
    path_convert = 'convert'
    
    def setup_path_to_inkscape(self,path_inkscape):
        if path_inkscape is None:
            p = sys.platform
            if p == "darwin":
                self.path_inkscape = "/Applications/Inkscape.app/Contents/Resources/bin/inkscape"
            if p == "linux2" or p == "linux":
                self.path_inkscape = "inkscape"
            if p == "win32" or p == "win64":
                exit("Unsupported operating system, please type format c: in the command prompt")
        else:
            self.path_inkscape = path_inkscape
            
    def setup_path_to_convert(self,path_convert):
        if path_convert is None:
            p = sys.platform
            if p == "darwin":
                self.path_convert = "convert"
            if p == "linux2" or p == "linux":
                self.path_convert = "convert"
            if p == "win32" or p == "win64":
                exit("Unsupported operating system, please type format c: in the command prompt")
        else:
            self.path_convert = path_convert    
    
    def __init__(self,path_inkscape=None,path_convert=None):
        self.setup_path_to_inkscape(path_inkscape)
        self.setup_path_to_convert(path_convert)
        
    def svg2png(self,width,height,png_file,svg_file,options=None):
        w = width
        h = height
    
        if not isinstance(width,str):
            w = str(width)
        if not isinstance(height,str):
            h = str(height)
        
        cmd = self.path_inkscape + ' --without-gui --file="'+svg_file+'"'
        if options is not None:
            cmd = cmd + " " + options
        cmd = cmd + ' --export-png="'+png_file+'" --export-width='+w+' --export-height='+h    
        os.system(cmd)
        #print cmd

    def xcf2png(self,width,height,out_file,in_file):
        w = width
        h = height
    
        if not isinstance(width,str):
            w = str(width)
        if not isinstance(height,str):
            h = str(height)
        
        cmd = self.path_convert + ' "' + in_file + '"'
        cmd = '{} -background transparent -flatten -scale {}x{} "{}"'.format(cmd,w,h,out_file)
        os.system(cmd)

    def xcf2pdf(self,width,height,out_file,in_file):
        w = width
        h = height
    
        if not isinstance(width,str):
            w = str(width)
        if not isinstance(height,str):
            h = str(height)
        
        cmd = self.path_convert + ' "' + in_file + '"'
        cmd = '{} -background transparent -flatten -scale {}x{} "{}"'.format(cmd,w,h,out_file)
        os.system(cmd)

    def xcf2pngR2(self,width2x,height2x,out_file,in_file):
        width1x = width2x/2
        height1x = height2x/2    
        out_file2x = out_file.replace('.png','@2x.png')    
        self.xcf2png(width1x,height1x,out_file,in_file)
        self.xcf2png(width2x,height2x,out_file2x,in_file)

    def xcf2pngR(self,width1x,height1x,out_file,in_file):
        width2x = width1x*2
        height2x = height1x*2
        out_file2x = out_file.replace('.png','@2x.png')    
        self.xcf2png(width1x,height1x,out_file,in_file)
        self.xcf2png(width2x,height2x,out_file2x,in_file)

    def svg2pngR2(self,width2x,height2x,out_file,in_file):
        width1x = width2x/2
        height1x = height2x/2    
        out_file2x = out_file.replace('.png','@2x.png')    
        self.svg2png(width1x,height1x,out_file,in_file)
        self.svg2png(width2x,height2x,out_file2x,in_file)

    def svg2pngR(self,width1x,height1x,out_file,in_file):
        width2x = width1x*2
        height2x = height1x*2
        out_file2x = out_file.replace('.png','@2x.png')    
        self.svg2png(width1x,height1x,out_file,in_file)
        self.svg2png(width2x,height2x,out_file2x,in_file)
        
        
    def svg2icns(self,icon_svg,icon_icns):
        icon_sizes = [16,32,32,64,128,256,256,512,512,1024]
        icon_names = ['16x16','16x16@2x','32x32','32x32@2x','128x128','128x128@2x','256x256','256x256@2x','512x512','512x512@2x']

        tmp_folder = '/tmp/r_icon.iconset/'

        os.mkdir(tmp_folder)

        i=0
        for icon_size in icon_sizes:
            icon_name=icon_names[i]    
            icon_size=str(icon_size)
            self.svg2png(icon_size,icon_size,tmp_folder+'icon_'+icon_name+'.png',icon_svg)
            i=i+1

        cmd = 'iconutil -c icns ' + tmp_folder + ' --output ' + icon_icns
        os.system(cmd)

        cmd = 'rm -fdr '+tmp_folder
        os.system(cmd)
