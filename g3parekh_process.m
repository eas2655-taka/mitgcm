% mitgcm binary output --> netCDF
close all
clear all

base = 'g3parekh_';
run = 'anthro_all';
N = 8;

fin = {'Ttave' 'Stave' 'PTRtave01' 'PTRtave02' 'PTRtave03' 'PTRtave04' 'PTRtave05' 'PTRtave06'};
fout= {'T' 'S' 'DIC' 'Alk' 'PO4' 'DOP' 'O2' 'dFe'};
unit= {'degree C' 'psu' 'molm^{-3}' 'molm^{-3}' 'molm^{-3}' 'molm^{-3}' 'molm^{-3}' 'molm^{-3}'};

% set source dir
sdir = '/nv/hp5/takamitsu3/data/PS_SO_C/anthro_all/run0/'

for n=1:N

% read in file name
input.fin  = [sdir,fin{n}];
input.fout = [base,run,'_',fout{n}];
input.vname= fout{n};
input.longname = fout{n};
input.unit     = unit{n};
input.modelsrc = 'MITgcm Georgia Tech version';

% model time step
input.dT   = 43200;
input.YR0  = 1900;

% model coordinate
input.x = [sdir,'XC'];
input.y = [sdir,'YC'];
input.z = [sdir,'RC'];

% call rdmds_nc function;

rdmds_nc(input);

end

