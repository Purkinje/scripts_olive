function multi_abf_to_image()

dir = uigetdir;
% cd ..
[p f] = subdir(dir); %extract subdirectories (p) and filenames (f) therein
figure;
set(gcf,'color','w');
aviobj = avifile('epspipsp.avi','compression','None'); %write an aviobject file name can be changed accordingly


for ii=1:length(f)

    cd(p{ii}); %make sure to be in right subdir
    sf = f{ii};


    
    for jj=1:length(sf)
    
	fullfilename = sf{jj};
    strout=strcat( num2str(jj), '/ ', num2str(length(f)) );
    disp(strout);
        
     
    if(strfind(fullfilename,'.abf')) %is an abf file found then proceed
 
        
        if(ii==1) %if first file then get color axis limits and use for all abf files
          
            abf_to_image(char(fullfilename),0, 0)
            
            cmapax = caxis;
            assignin('base','cmapax',cmapax);
            caxis manual;
            %caxis([cmapax(1) cmapax(2)]);
            %caxis([-64.51416159825389 -51.87988397210577]);
             caxis([ -65 -40]);
            aviobj=addframe(aviobj, gcf); % 'gcf' can handle if you zoom in to take a movie.
        else 
            
            abf_to_image(char(fullfilename),cmapax(1), cmapax(2))
            aviobj=addframe(aviobj, gcf);% 'gcf' can handle if you zoom in to take a movie.


        end
         
    end
    
    end
    
    
    
end

aviobj=close(aviobj); % close movie write object
