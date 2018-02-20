% mitgcm binary output --> netCDF
close all
clear all

addpath /nv/hp/takamitsu3/matlab

% set source dir
sdir = '/nv/hp5/takamitsu3/scratch/najjar/'

% read in file name
input.fin  = [sdir,'O2'];
input.fout = 'O2';
input.vname= 'O2';
%input.longname = 'Dissolved Inorganic Carbon';
input.longname = 'Dissolved Oxygen';
input.unit     = 'mol per m3';
input.modelsrc = 'MITgcm Georgia Tech version';

% model time step
input.dT   = 43200;
input.YR0  = 0;

% model coordinate
input.x = [sdir,'XC'];
input.y = [sdir,'YC'];
input.z = [sdir,'RC'];

% call rdmds_nc function;
rdmds_nc(input);

% read in file name
input.fin  = [sdir,'PO4'];
input.fout = 'PO4';
input.vname= 'PO4';
input.longname = 'Phosphate';
input.unit     = 'mol per m3';

% call rdmds_nc function;
rdmds_nc(input);

% read in file name
input.fin  = [sdir,'pCO2'];
input.fout = 'pCO2';
input.vname= 'pCO2';
input.longname = 'surface water partial pressure of CO2';
input.unit     = 'atm';

% call rdmds_nc function;
rdmds_nc(input);

% read in file name
input.fin  = [sdir,'T'];
input.fout = 'T';
input.vname= 'T';
input.longname = 'potential temperature';
input.unit     = 'degree C';

% call rdmds_nc function;
rdmds_nc(input);

% read in file name
input.fin  = [sdir,'S'];
input.fout = 'S';
input.vname= 'S';
input.longname = 'salinity';
input.unit     = 'psu';

% call rdmds_nc function;
rdmds_nc(input);

