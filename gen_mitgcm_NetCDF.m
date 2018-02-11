%% ------------------------------------------------------------------------
% MATLAB code
% [gen_mitgcm_NetCDF.m]
%
%   Generate NetCDF from MITgcm binary output. MITgcm output is in
%  three-dimensional+time(year) [lon,lat,depth,time].
%
%   When you run this code, it will create "o2_MITgcm_CTL_raw.nc".
%  To create time stamp information, use CDO command,
%  $ cdo cdo settaxis,1900-1-1,12:00:00,1year o2_MITgcm_CTL_raw.nc o2_MITgcm_CTL_taxis.nc
%  (o2_MITgcm_CTL_raw.nc (input) and o2_MITgcm_CTL_taxis.nc (output)).
%
% Yohei Takano, Feb 10th, 2018, (development)
%               XXX XXth, 2018, XXX                       
%
%% ------------------------------------------------------------------------
clear all
close all
clear memory

%% 1. Load MATLAB formatted files (MITgcm output and grid)
%% ----------
load o2_MITgcm_CTL.mat

%addpath ../data/misc/
load grid_MITgcm3deg.mat
%d=2.8125;
%lon=d/2:d:360-d/2;
%lat=-90+d/2:d:90-d/2;
%depth = [1:23]*10;

% ----- prepared data for NetCDF -----
o2 = o2_MITgcm_CTL(:,:,:,1:201);
V = squeeze(o2);
% ----- prepare data for NetCDF -----

%% 2. Coordinate and time information
%% ----------
depth = -depth;
time = (1900:2100)'; % annual mean output from 1900-2100

% ----- prepare grid and time data for NetCDF -----
X = lon;   % longitude
Y = lat;   % latitude
Z = depth; % depth
T = time;  % time
% ----- prepare grid and time data for NetCDF -----

%% 3. Generate NetCDF file
%% ----------
% 3-1. Define file name
scope = netcdf.create('o2_MITgcm_CTL_raw.nc','netcdf4');

% 3-2. Define constants (filling or missing values)
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
netcdf.putAtt(scope,varid,'long_name','time since 1900');
netcdf.putAtt(scope,varid,'units','year');
netcdf.defVarFill(scope,varid,false,fillValue);
netcdf.putVar(scope,varid,T);

% 3-5. Define variable attributes
netcdf.putAtt(scope,NC_GLOBAL,'title','Dissolved Oxygen from MITgcm-CTL')
netcdf.putAtt(scope,NC_GLOBAL,'long_title','Dissolved Oxygen frim MITgcm Control Experiment in NetCDF file')

netcdf.putAtt(scope,NC_GLOBAL,'comments','Raw Data from Sensitivity Experiments')
netcdf.putAtt(scope,NC_GLOBAL,'institution','Georgia Institute of Technology MITgcm')
netcdf.putAtt(scope,NC_GLOBAL,'source','MITgcm global3_v3')

netcdf.putAtt(scope,NC_GLOBAL,'Conventions','CF-1.6')

netcdf.putAtt(scope,NC_GLOBAL,'CreationDate',datestr(now,'yyyy/mm/dd HH:MM:SS'))
netcdf.putAtt(scope,NC_GLOBAL,'CreatedBy',getenv('LOGNAME'))

netcdf.close(scope)
scope = netcdf.open('o2_MITgcm_CTL_raw.nc','WRITE'); % here we use 'WRITE' because the file already exists

% 3-6. Define and store variables
varname = 'o2';
long_name = 'Dissolved Oxygen';
unit = 'mmol m-3';

varid = netcdf.defVar(scope,varname,'double',[dimidX,dimidY,dimidZ,dimidT]);
netcdf.putAtt(scope,varid,'long_name',long_name);
netcdf.putAtt(scope,varid,'units',unit);
netcdf.defVarFill(scope,varid,false,fillValue);

V(isnan(V)) = fillValue;
%-- V(V == 0) = fillValue;
netcdf.putVar(scope,varid,V);
netcdf.close(scope) % now insert three-dimensional data to NetCDF file

disp('Finish !!!');
%% ------------------------------------------------------------------------