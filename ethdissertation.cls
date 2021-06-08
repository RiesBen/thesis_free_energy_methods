
% Document class for a dissertation at the ETH Zurich
% written by Noah S. Bieler 
%

\NeedsTeXFormat{LaTeX2e}[2014/01/01]
\ProvidesClass{ethdissertation}[2014/11/25 v1.0
        LaTeX document class for a dissertation at the ETH Zurich]


\DeclareOption{handin}{
    \def\@papersize{a4paper}
    \def\@linespacing{doublespacing}
    \def\@fontsize{11pt}
}

\DeclareOption{publish}{
    \def\@papersize{a5paper}
    \def\@linespacing{onehalfspacing}
    \def\@fontsize{8pt}
}

\ExecuteOptions{handin}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}

\ProcessOptions \relax

\PassOptionsToClass{fleqn}{book}
\LoadClass[twosided,\@papersize,\@fontsize]{book}

\usepackage{scrextend}
%\changefontsizes[11pt]{11pt}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some standard packages
\RequirePackage[fleqn]{amsmath}
\RequirePackage{amssymb}
\RequirePackage{fontspec}

%\RequirePackage{palatino}
%\fontspec{Palatino}
%\RequirePackage{mathpazo}
%\RequirePackage{unicode-math}
%\setmathfont[math-style=ISO,bold-style=ISO,vargreek-shape=TeX]{TeX Gyre Pagella Math}
%\renewcommand\familydefault{cmss}
%\RequirePackage[euler-digits]{eulervm}
%\RequirePackage{euler}
\RequirePackage{float}
\RequirePackage{microtype}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{colortbl}
\RequirePackage[export]{adjustbox}
\RequirePackage{epstopdf}
\RequirePackage{subcaption}
\RequirePackage[ddmmyy,hhmmss]{datetime}
\RequirePackage[nomessages]{fp}
\RequirePackage{tikz} 
\RequirePackage{pgfplots}
\RequirePackage{import}
\pgfplotsset{compat=1.13}
\RequirePackage[version=4]{mhchem}
%\RequirePackage{hyperref}
%\RequirePackage{chemfig}
%\RequirePackage[floats=float]{chemstyle}
%\RequirePackage{chemgreek}
%\RequirePackage{chemmacros}
%\usetikzlibrary{positioning}

\providecommand*\standardstate{%
  {%
    \ensuremath{\protect\cst@standardstate}%
  }%
}
\newcommand*\cst@standardstate{%
  \mathpalette\cst@standardstate@aux\circ
}
\newcommand*\cst@standardstate@aux[2]{%
  \ooalign{%
    \hfil
    $#1-$%
    \hfil
    \cr
    \hfil
    $#1#2$%
    \hfil
    \cr
  }%
}

\RequirePackage{nameref}         % reference section name
\usepackage{dcolumn}
\newcolumntype{.}{D{.}{.}{-1}}

\newcommand{\bracket}[1]{%
[\citen{#1}]
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Geometry
\RequirePackage[ vmargin={0.100\paperheight, 0.120\paperheight}  % top, bottom
               , hmargin={0.165\paperwidth, 0.165\paperwidth}  % inner, outer
               , bindingoffset=0.00\paperwidth
               , headheight=20pt
               ]{geometry}
%\RequirePackage[onehalfspacing]{setspace}
%\newcommand{\@thelinespacing}{doublespacing}
\RequirePackage[\@linespacing]{setspace}
%\RequirePackage[doublespacing]{setspace}
%\linespread{1.3}

\RequirePackage[ font={small,singlespacing}
               , labelfont=sc
               ]{caption}
%\RequirePackage[section]{placeins}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Chapter Fonts
%\RequirePackage{sectsty}
%\chapterfont{\LARGE}
\RequirePackage[explicit]{titlesec}

%\titleformat{\chapter}[display] %?
% {\bfseries\LARGE}
% {
% %\begin{minipage}[b][72pt][b]{1.1\textwidth}
%   %\filleft \fontsize{72}{72} \selectfont \thechapter
% \begin{minipage}[b][48pt][b]{1.1\textwidth}
%   \filleft \fontsize{48}{48} \selectfont \thechapter
% \end{minipage}
% }
% %{-92pt}
% {-64pt}
% {
% %\begin{minipage}[b][72pt][t]{0.95\textwidth}
% \begin{minipage}[b][48pt][t]{0.95\textwidth}
%  #1
% \end{minipage}
%% \begin{minipage}[c][82pt]{0.05\textwidth}
%%%
%% \end{minipage}
% \bigskip
%}
\definecolor{ChapterGreen}{HTML}{1e8449 }

\titleformat{\chapter}[display] %?
 {\bfseries\LARGE}
 { 
 \begin{minipage}[96pt]{1.1\textwidth}
   \filleft \color{ChapterGreen}{\fontsize{96}{96} \selectfont \thechapter}
 \end{minipage}
 }
 {-54pt}
 {
  \begin{minipage}[48pt]{0.85\textwidth}
   #1
  \end{minipage}
 \bigskip
}

%\titlespacing{\chapter}{0pt}{0pt}{*12}
\titlespacing{\chapter}{0pt}{0pt}{*8}
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Various other sectioning headers
\newcommand{\sectype}{}
\titleformat{\section}
 {\centering\Large}
 {\sectype{} \textls{\thesection} }
 { 0pt}
 {
 \textls{\MakeUppercase{#1}}
}
%\titlespacing*{\section}{0pt}{*8}{*4}
\titlespacing*{\section}{0pt}{*7}{*4}

\titleformat{\subsection}
 {\large\sc}
 {\thesubsection }
 { 0pt}
 {  #1 }
%\titlespacing*{\subsection}{0pt}{*7}{*3}
\titlespacing*{\subsection}{0pt}{*4}{*2}

\titleformat{\subsubsection}
 {\sc}
 { }
 { 0pt}
 { #1 }
%\titlespacing*{\subsubsection}{0pt}{*6}{*2}
\titlespacing*{\subsubsection}{0pt}{*2}{1em}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nice headers
\RequirePackage{fancyhdr}
\pagestyle{fancy}

\renewcommand{\chaptermark}[1]{
 \markboth{\upshape\MakeUppercase{#1}}{}
}

\renewcommand{\headrulewidth}{0.4pt}
\newcommand{\headerrulespacing}{}

\let\oldl@chapter\l@chapter
\def\l@chapter#1#2{\oldl@chapter{#1}{$#2$}}

\let\old@dottedcontentsline\@dottedtocline
\def\@dottedtocline#1#2#3#4#5{%
\old@dottedcontentsline{#1}{#2}{#3}{#4}{{$#5$}}}
  
\newcommand{\leftpage}{\Large $\thepage$}
\newcommand{\rightpage}{\Large $\thepage$}
        

%\renewcommand{\sectionmark}[1]{\markright{\thesection\enspace \MakeUppercase{#1}}}
\renewcommand{\sectionmark}[1]{\markright{\upshape\MakeUppercase{#1}}}
%\newcommand{\newleftmark}{\MakeUppercase{\chaptername} \thechapter:\enspace \leftmark}
\newcommand{\newleftmark}{ \thechapter\enspace \upshape \leftmark}

\fancypagestyle{main} {
    \fancyhead{}
    \fancyfoot{}

    \ifx \@onesided \undefined

        \fancyhead[CE]{\headerrulespacing \textls{\newleftmark} }
        \fancyhead[CO]{\headerrulespacing \textls{\thesection\enspace \upshape\rightmark} }
        
        \fancyhead[RO]{\rightpage}
        \fancyhead[LE]{\leftpage}
    \else
        \fancyhead[C]{\headerrulespacing \textls{\thesection\enspace \rightmark} }
        \fancyhead[R]{\rightpage}
    \fi
}

\fancypagestyle{si} {
    \fancyhead{}
    \fancyfoot{}

    \ifx \@onesided \undefined

        \fancyhead[CE]{\headerrulespacing \upshape\textls{\newleftmark} }
        \fancyhead[CO]{\headerrulespacing \upshape\textls{\rightmark} }
        
        \fancyhead[RO]{\rightpage}
        \fancyhead[LE]{\leftpage}
    \else
        \fancyhead[C]{\headerrulespacing \upshape\textls{\rightmark} }
        \fancyhead[R]{\rightpage}
    \fi
}

\fancypagestyle{plain} {
    \fancyhf{}
    \fancyhead[C]{\headerrulespacing \upshape\textls{\leftmark} }
    \fancyhead[R]{\rightpage}
}

\fancypagestyle{frontback} {
    \fancyhf{}
    \fancyhead[C]{\headerrulespacing \upshape\textls{\leftmark}}
    \ifx \@onesided \undefined
        \fancyhead[RO]{\rightpage}
        \fancyhead[LE]{\leftpage}
    \else
        \fancyhead[R]{\rightpage}
    \fi
}

% Set the styles with the *matter commands
\let\oldfront\frontmatter
\renewcommand{\frontmatter}{\oldfront \pagestyle{frontback}}
\let\oldback\backmatter
\renewcommand{\backmatter}{\oldback \pagestyle{frontback}}
\let\oldmain\mainmatter
\renewcommand{\mainmatter}{\oldmain\pagestyle{main}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dedication
\newcommand{\dedication}[1]{
 \thispagestyle{empty}
 \cleardoublepage
 \thispagestyle{empty}
 \null\vspace{\stretch{3}}
%    \begin{flushright}
 \hfill%
 \begin{minipage}{5cm}
        \begin{flushright}
        \textit{#1}
        \end{flushright}
      \end{minipage}
%    \end{flushright}
 \vspace{\stretch{1}}
 \clearpage{ \thispagestyle{empty} \cleardoublepage}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quotes at the beginning
\RequirePackage{booktabs}
\RequirePackage{epigraph}

\setlength{\epigraphwidth}{0.55\textwidth}

\newcommand{\aquote}[2]{
 %\vspace{-2em}
 \epigraph{\textit{#1}}{#2}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title Page
\newcommand{\currenttitle}[1]{\def\@currenttitle{#1}}
\newcommand{\thecurrenttitle}{\@currenttitle}

\newcommand{\wantedtitle}[1]{\def\@wantedtitle{#1}}
\newcommand{\thewantedtitle}{\@wantedtitle}

\newcommand{\thesisnumber}[1]{\def\@thesisnumber{#1}}
\newcommand{\thethesisnumber}{\@thesisnumber}

\newcommand{\thetitle}{\@title}
\renewcommand{\title}[1]{\def\@title{#1}}

\newcommand{\theauthor}{\@author}
\renewcommand{\author}[1]{\def\@author{#1}}

\newcommand{\citizen}[1]{\def\@citizen{#1}}
\newcommand{\thecitizen}{\@citizen}

\newcommand{\examiner}[1]{\def\@examiner{#1}}
\newcommand{\theexaminer}{\@examiner}

\newcommand{\coexaminer}[2]{\def\@coexaminer{#1}\def\@coexaminertwo{#2}}
\newcommand{\thecoexaminer}{\@coexaminer}
\newcommand{\thecoexaminertwo}{\@coexaminertwo}

\renewcommand{\date}[1]{\def\@date{#1}}
\newcommand{\thedate}{\@date}

\newcommand{\birthdate}[1]{\def\@birthdate{#1}}
\newcommand{\thebirthdate}{\@birthdate}


\renewcommand{\maketitle}{
 \begin{titlepage}
  \begin{center}
   DISS. ETH NO. \thethesisnumber

   \vspace{1.5em}
   
   {\LARGE \bfseries \thetitle}
   
   \vspace{3em}
   
   A thesis submitted to attain the degree of 
   
   \vspace{1em}
   
   \thewantedtitle
   
   \vspace{1.5em}
   
   presented by 
   
   \vspace{1em}
   
   {\Large \theauthor }
   
   \vspace{1.5em}
   
   \thecurrenttitle
   
   \vspace{1.5em}
   
   born on \thebirthdate \\
   citizen of 
   \thecitizen
   
   \vspace{4em}
   
   accepted on the recommendation of
   
   \vspace{1.5em}
   
   \theexaminer, examiner
   
   \vspace{0.5em}
   
   \thecoexaminer, co-examiner\\
   \thecoexaminertwo, co-examiner
   
   \vspace{1.5em}
   
   \thedate
  \end{center}
 \end{titlepage}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Useful commands

\newcommand{\latin}[1]{%
\textit{#1}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SECTIONS

\newenvironment{abstract}{\begin{quote}}{\end{quote}}

\newenvironment{acknowledgement}{\section*{Acknowledgment}}{}

\newenvironment{ethappendix}
    {
      \renewcommand{\sectype}{Appendix }
%      \numberwithin{equation}{section}
      \renewcommand{\thesection}{\arabic{chapter}.\Alph{section}}
      \renewcommand{\theequation}{\arabic{chapter}.\Alph{section}.\arabic{equation}}
      \renewcommand{\thefigure}{\arabic{chapter}.\Alph{section}.\arabic{figure}}
      \renewcommand{\thetable}{\arabic{chapter}.\Alph{section}.\arabic{table}}
      \setcounter{section}{0}
    }
    {}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CV stuff
\newcommand{\cvsection}[1]{ \subsection*{#1} }

\newenvironment{cvlist}
{
    \begin{tabular}{lp{0.2\textwidth}p{0.7\textwidth}}
}
{
    \end{tabular}
}

\newcommand{\cventry}[2]{ & #2 & #1 \\ }
