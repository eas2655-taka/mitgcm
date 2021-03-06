% mitgcm binary output --> netCDF

close all
clear all

% read in file name
fin  = 'PTRtave01';
fout = 'DIC';
vname= 'DIC';
longname = 'Dissolved Inorganic Carbon';
unit     = 'mol per m3';
modelsrc = 'MITgcm Georgia Tech version';

% model time step
dT   = 43200;
YR0  = 1900;

% coordinate
xin  = 'XC';
yin  = 'YC';
zin  = 'RC';

% model year
yr2sec = 86400*360;
 
% read in data
lon=rdmds(xin); X = squeeze(lon(:,1));
lat=rdmds(yin); Y = squeeze(lat(1,:));
Z=-squeeze(rdmds(zin));
[V,iter]=rdmds(fin,NaN);

% define (year since 0000-00-00)
T0 = (iter-iter(1))*dT/yr2sec;
T = YR0 + T0 + (T0(2)-T0(1))*.5;

%% 3. Generate NetCDF file
scope = netcdf.create([fout,'.nc'],'netcdf4');
NC_GLOBAL = netcdf.getConstant('NC_GLOBAL');
fillValue = -99999;

% 3-3. Define dimensions
dimidX = netcdf.defDim(scope,'lon',length(X));
dimidY = netcdf.defDim(scope,'lat',length(Y));
dimidZ = netcdf.defDim(scope,'depth',length(Z)); % turn on if you have depth directions
dimidT = netcdf.defDim(scope,'time',length(T));

% 3-4. Define coordinates and time axis
varid = netcdf.defVar(scope,'lon','double',[dimidX]);
netcdf.putAtt(scope,varid,'standard_name','lon');
netcdf.putAtt(scope,varid,'long_name','longitude');
netcdf.putAtt(scope,varid,'units','degrees_east');
netcdf.defVarFill(scope,varid,false,fillValue);
netcdf.putVar(scope,varid,X);

varid = netcdf.defVar(scope,'lat','double',[dimidY]);
netcdf.putAtt(scope,varid,'standard_name','lat');
netcdf.putAtt(scope,varid,'long_name','latitude');
netcdf.putAtt(scope,varid,'units','degrees_north');
netcdf.defVarFill(scope,varid,false,fillValue);
netcdf.putVar(scope,varid,Y);

varid = netcdf.defVar(scope,'depth','double',[dimidZ]);
netcdf.putAtt(scope,varid,'standard_name','depth');
netcdf.putAtt(scope,varid,'long_name','depth from the surface ocean');
netcdf.putAtt(scope,varid,'units','m');
netcdf.defVarFill(scope,varid,false,fillValue);
netcdf.putVar(scope,varid,Z);

varid = netcdf.defVar(scope,'time','double',[dimidT]);
netcdf.putAtt(scope,varid,'standard_name','time');
netcdf.putAtt(scope,varid,'long_name','years since 0000-00-00 00:00:00');
netcdf.putAtt(scope,varid,'units','year');
netcdf.defVarFill(scope,varid,false,fillValue);
netcdf.putVar(scope,varid,T);

% 3-5. Define variable attributes
netcdf.putAtt(scope,NC_GLOBAL,'title',[vname,' from MITgcm'])
netcdf.putAtt(scope,NC_GLOBAL,'long_title',[vname,' from MITgcm in NetCDF file'])

netcdf.putAtt(scope,NC_GLOBAL,'comments','Raw Data')
netcdf.putAtt(scope,NC_GLOBAL,'institution','Georgia Institute of Technology MITgcm')
netcdf.putAtt(scope,NC_GLOBAL,'source',modelsrc)

netcdf.putAtt(scope,NC_GLOBAL,'Conventions','CF-1.6')

netcdf.putAtt(scope,NC_GLOBAL,'CreationDate',datestr(now,'yyyy/mm/dd HH:MM:SS'))
netcdf.putAtt(scope,NC_GLOBAL,'CreatedBy',getenv('LOGNAME'))

netcdf.close(scope)
scope = netcdf.open([vname,'.nc'],'WRITE'); % here we use 'WRITE' because the file already exists

% 3-6. Define and store variables
varname = vname;
long_name = longname;

varid = netcdf.defVar(scope,varname,'double',[dimidX,dimidY,dimidZ,dimidT]);
netcdf.putAtt(scope,varid,'long_name',long_name);
netcdf.putAtt(scope,varid,'units',unit);
netcdf.defVarFill(scope,varid,false,fillValue);

% enter fill value
V(isnan(V)) = fillValue;
V(V==0) = fillValue;

netcdf.putVar(scope,varid,V);
netcdf.close(scope) % now insert three-dimensional data to NetCDF file

disp('Finish !!!');


