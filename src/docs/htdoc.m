function htdoc(topic)
% function htdoc(topic)
% opens mtoc++ documentation in a browser
%
% Opens documentation generated by mtoc++ and doxygen in a browser. The
% directory where the HTML documentation is installed must be geiven by the
% 'DOXYGEN_DIR' environment variable. This can be set with
% @code
%   setenv('DOXYGEN_DIR', '/path/to/doxygen/docu');
% @endcode
% in the 'startup.m' file, e.g.
%
% Parameters:
%  topic:     a string or an object describing for which the documentation
%             site shall be opened.

doxy_dir = getenv('DOXYGEN_DIR');
if isempty(doxy_dir) || ~exist(fullfile(doxy_dir, 'index.html'), 'file')
  error('Environment variable DOXYGEN_DIR needs to be set to a valid documentation directory!');
end

if ~ischar(topic)
  classname = class(topic);
else
  toks = get_tokens(topic);
  classname = get_max_token(toks);
end

[st, res]=system(['grep -l ''<h1>', classname, ' '' ', fullfile(getenv('DOXYGEN_DIR'), '*'), ' | head -1' ]);
if isempty(res)
  funcname = regexprep(which(classname), '\\.m$', '');
  funcname = strrep(funcname, [rbmatlabhome, filesep], '');
  [st, res]=system(['grep -l ''<h1>', funcname, ' '' ', fullfile(getenv('DOXYGEN_DIR'), '*'), ' | head -1' ]);
end
if isempty(res)
  error(['Could not find any entry for object ', classname, '.']);
end


web(res, '-browser');

function toks = get_tokens(topic)
  toks = textscan(topic, '%s', 'Delimiter', './');
  toks = toks{1};

function mtok = get_max_token(toks)

  mtok_temp = toks{1};
  for i= length(toks)-1:-1:1
    mtok = [mtok_temp, sprintf('.%s', toks{2:i})];
    if ~isempty(which(mtok))
      return;
    end
  end
  mtok      = toks{1};
