clc;
clear functions;

old_dir = cd(fileparts(which(mfilename)));

NAMES = { ...
  'FresnelCS', ...
  'XY_to_angle', ...
  'CircleArcMexWrapper', ...
  'BiarcMexWrapper', ...
  'BiarcListMexWrapper', ...
  'LineSegmentMexWrapper', ...
  'PolyLineMexWrapper', ...
  'Triangle2DMexWrapper', ...
  'ClothoidCurveMexWrapper', ...
  'ClothoidListMexWrapper', ...
  'ClothoidSplineG2MexWrapper', ...
  'TriTriOverlap'
};

LIB_NAMES = { ...
  'Utils/fmt/format.cc', ...
  'Utils/fmt/os.cc' ...
  'AABBtree.cc', ...
  'Biarc.cc', ...
  'BiarcList.cc', ...
  'Circle.cc', ...
  'Clothoid.cc', ...
  'ClothoidAsyPlot.cc', ...
  'ClothoidDistance.cc', ...
  'ClothoidG2.cc', ...
  'ClothoidList.cc', ...
  'Console.cc', ...
  'Fresnel.cc', ...
  'G2lib.cc', ...
  'G2lib_intersect.cc', ...
  'GenericContainer.cc', ...
  'GenericContainerCinterface.cc', ...
  'GenericContainerSupport.cc', ...
  'GenericContainerTables.cc', ...
  'Line.cc', ...
  'Malloc.cc', ...
  'Numbers.cc', ...
  'PolyLine.cc', ...
  'PolynomialRoots-1-Quadratic.cc', ...
  'PolynomialRoots-2-Cubic.cc', ...
  'PolynomialRoots-3-Quartic.cc', ...
  'PolynomialRoots-Jenkins-Traub.cc', ...
  'PolynomialRoots-Utils.cc', ...
  'Trace.cc', ...
  'Triangle2D.cc', ...
  'Utils.cc', ...
};

MROOT = matlabroot;

CMDBASE = 'mex -c -largeArrayDims -Isrc -Isrc/Utils ';
if isunix
  CMDBASE = [CMDBASE, 'CXXFLAGS="\$CXXFLAGS -Wall -O2 -g" '];
elseif ispc
end

%for k=1:length(NAMES)
%  N=NAMES{k};
%  disp('---------------------------------------------------------');
%  fprintf(1,'Compiling: %s\n',N)
%  CMD = [CMDBASE ' -c src_mex/mex_' N '.cc' ];
%  disp('---------------------------------------------------------');
%  disp(CMD);
%  eval(CMD);
%end

LIB_OBJS = '';
for k=1:length(LIB_NAMES)
  [filepath,bname,ext] = fileparts(LIB_NAMES{k});
  NAME = [' src/', filepath, '/', bname, ext ];
  if isunix
    LIB_OBJS = [ LIB_OBJS, bname, '.o ' ];
  elseif ispc
    LIB_OBJS = [ LIB_OBJS, bname, '.obj ' ];
  end
  CMD = [CMDBASE ' -c ' NAME];
  disp('---------------------------------------------------------');
  disp(CMD);
  eval(CMD);
end

for k=1:length(NAMES)
  N=NAMES{k};
  disp('---------------------------------------------------------');
  fprintf(1,'Compiling: %s\n',N);

  CMD = [ 'while mislocked(''' N '''); munlock(''' N '''); end;'];
  eval(CMD);

  CMD = [ 'mex -Isrc -output bin/', N ];
  CMD = [ CMD, ' -largeArrayDims src_mex/mex_', N ];
  CMD = [ CMD, '.cc ', LIB_OBJS ];

  if ismac
    CMD = [CMD, ' CXXFLAGS="\$CXXFLAGS -Wall -O2 -g"'];
  elseif isunix
    % Workaround for MATLAB 2020 that force dynamic link with old libstdc++
    % solution: link with static libstdc++
    % ARCH  = computer('arch');
    % PATH1 = [MROOT, '/bin/', ARCH];
    % PATH2 = [MROOT, '/extern/bin/', ARCH];
    CMD = [ CMD, ...
      ' CXXFLAGS="\$CXXFLAGS -Wall -O2 -g"' ...
      ' LDFLAGS="\$LDFLAGS -static-libgcc -static-libstdc++"' ...
      ' LINKLIBS="-ldl -L\$MATLABROOT/bin/\$ARCH -L\$MATLABROOT/extern/bin/\$ARCH -lMatlabDataArray -lmx -lmex -lmat -lm "' ...
    ];
  elseif ispc
  end

  disp(CMD);
  eval(CMD);
end

if isunix
  delete *.o
else
  delete *.obj
end

cd(old_dir);

disp('----------------------- DONE ----------------------------');
