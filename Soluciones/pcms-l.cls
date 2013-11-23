%%% ====================================================================
%%% @LaTeX-file{
%%%    filename  = "pcms-l.cls",
%%%    version   = "1.2d",
%%%    date      = "1997/01/02",
%%%    time      = "16:00:58 EST",
%%%    checksum  = "31141 554 1081 16347",
%%%    author    = "Barbara Beeton",
%%%    address   = "American Mathematical Society, PO Box 6248,
%%%                       Providence, RI 02940, USA",
%%%    email     = "tech-support@ams.org (Internet)",
%%%    supported = "yes",
%%%    abstract  = "This is a LaTeX documentclass for the IAS/Park City
%%%                 Mathematics Series.",
%%%    docstring = "The checksum field above contains a CRC-16 checksum
%%%                 as the first value, followed by the equivalent of
%%%                 the standard UNIX wc (word count) utility output
%%%                 of lines, words, and characters.  This is produced
%%%                 by Robert Solovay's checksum utility.",
%%% }
%%% ====================================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{pcms-l}
              [1997/01/02 v1.2d PCMS Author Class]

\newif\ifLecture \Lecturefalse
\newif\ifMonograph \Monographtrue

\DeclareOption{lecture}{\Monographfalse\Lecturetrue}
\DeclareOption{monograph}{\Monographtrue\Lecturefalse}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{amsbook}}
\ProcessOptions

\LoadClass{amsbook}[1996/10/24]


% part

\def\partname{PART}

\def\part{\cleardoublepage \pagestyle{empty}\thispagestyle{empty}%
  \null\vfil  \markboth{}{}\secdef\@part\@spart}

\def\@part[#1]#2{%
  \refstepcounter{part}
    \addcontentsline{toc}{part}{\partname\ \thepart\protect\newline #1}%
  \begingroup\bfseries
   \vspace*{8pc}%
   \ifodd\c@page\raggedleft\else\raggedright\fi
   \ifnum \c@secnumdepth >-2\relax
       {\Large \partname\ {\LARGE\thepart}} \vskip 8\p@ \fi
   \huge #1\endgraf
  \endgroup\vfill\newpage}

\def\@spart#1{\addcontentsline{toc}{part}{#1}%
  \begingroup\huge\bfseries
   \vspace*{8pc}%
   \ifodd\c@page\raggedleft\else\raggedright\fi
   #1\endgraf
  \endgroup}

\def\pauth#1{{\raggedleft\vspace*{2pc}%
	\LARGE\bfseries\noindent
	#1\endgraf\vfill\newpage}}

\def\abstract{%
  \global\let\abstract\relax
  \global\setbox\abstractbox=\vtop \bgroup
 \normalsize
  \trivlist \labelsep.5em\item[\hskip\labelsep
    {\bfseries\abstractname}.]\ignorespaces
}


%
%      CHAPTER TITLES
%

\def\LogoOn{\global\LogoOntrue}
\newif\ifLogoOn
\LogoOnfalse

\newcount\addressnum@
\newcount\addresscount@
%\newcounter{lecturenum}
\newcounter{lecture}

%    Permit the word `Lecture' to be replaced by, e.g., `Chapter'.
%    (The page style using \chapter is different and unacceptable for
%    a lecture series.)  [bnb, 1996/11/07]
\def\thelecturelabel{Lecture}
\def\thelecturename#1{}

\def\lecturelabel#1{\gdef\thelecturelabel{#1}}
\def\lecturename#1{\gdef\thelecturename{#1\unskip}}
\def\lecture{\global\Lecturetrue\global\Monographfalse
  \global\let\sectionmark\@gobble % \lecturemark will be used instead
  \addtocounter{lecture}1\relax
  \refstepcounter{chapter}%
%  \addtocounter{chapter}1\relax % this is done for section numbering
  {\Large\bfseries
   \raggedleft
   \@xp\uppercase\@xp{\thelecturelabel} {\LARGE\thelecturenum}\\
   \vspace*{3pt}%
   \thelecturename
   \endgraf}%
  \let\@secnumber=\thelecturenum
  \@xp\lecturemark\@xp{\thelecturename}%
  \addcontentsline{toc}{chapter}{%
    \thelecturelabel\ \thelecturenum.\ \thelecturename}%
  \vspace{34\p@}\noindent}

\def\chapter{\cleardoublepage \pagestyle{headings}%
  \setcounter{section}0\relax
  \ifMonograph
	\gdef\chaptername{Chapter}%
  \else
	\gdef\chaptername{Lecture}%
	\gdef\thelecturenum{\@arabic\c@lecture}%
  \fi
  \def\@address{}%
  \def\@curraddr{}%
  \def\@email{}%
  \addresscount@=\z@
  \ifLogoOn
%    For the first page of a lecture series, the copyright block will be
%    set with \setaddress as part of the first-page footnote.
%    [bnb, [1996/10/22]
	\thispagestyle{firstpage}%
  \else
	\thispagestyle{plain}%
  	\def\@textbottom{\global\let\@textbottom\@empty}%
  \fi
  \global\@topnum\z@
  \@afterindentfalse \secdef\@chapter\@schapter}
%
\def\@chapter[#1]#2{\refstepcounter{chapter}%
  \ifnum \c@secnumdepth <\z@ \let\thechapter\@empty\fi
  \typeout{\chaptername\space\thechapter}%
  \addcontentsline{toc}{chapter}{%
    \protect\numberline{%
      \ifx\thechapter\@empty\else\chaptername\ \thechapter.\fi}#1}%
  \chaptermark{#1}%
  \addtocontents{lof}{\protect\addvspace{10\p@}}%
  \addtocontents{lot}{\protect\addvspace{10\p@}}%
  \@makechapterhead{#2}\@afterheading}


\def\@schapter#1{\typeout{#1}%
 \ifLogoOn
 \else
   \@ifnotempty{#1}{\addcontentsline{toc}{chapter}{#1}}%
 \fi
% \ifMonograph
  \chaptermark{#1}%
% \fi
  \@ifnotempty{#1}{\gdef\thelectureseries{#1}}%
  \addtocontents{lof}{\protect\addvspace{10\p@}}%
  \addtocontents{lot}{\protect\addvspace{10\p@}}%
  \@makeschapterhead{#1}\@afterheading}


%
\def\@makechapterhead#1{%
  \begingroup \topskip 64pt\relax
    \ifodd\c@page\raggedleft\else\raggedright\fi
    \ifnum\c@secnumdepth>\m@ne
      \leavevmode
      {\Large\bfseries
              \uppercase\@xp{\chaptername}\enspace
       {\LARGE\bfseries\thechapter\par}}%
      \skip@34\p@
      \advance\skip@-\normalbaselineskip
      \vskip\skip@ {\huge\bfseries #1\par}%
    \fi
  \endgroup
  \skip@34\p@ \advance\skip@-\normalbaselineskip
  \vskip\skip@ }
%


\def\@makeschapterhead#1{%
 \ifLogoOn
	\global\LogoOnfalse
 \fi
	\vtop to 8pc{\vfill
 \ifodd\c@page
    \ifx#1\contentsname
          \raggedright
    \else
          \raggedleft\fi
  \else\raggedright\fi
  {\huge\bfseries #1\par}%
}%\endgroup
\skip@34\p@\advance\skip@-\normalbaselineskip
  \vskip\skip@ }

%      Sectioning commands


\def\auth#1{\vspace{-1pc}{\raggedleft
	\Large\bf\noindent
	#1\endgraf
	\vspace*{2pc}
        }
        \def\@author{#1}%
}


\def\specialsection{\@startsection{specialsection}{0}%
  \z@{-1.5\linespacing\@plus-1\linespacing}{.5\linespacing}%
  {\Large\bfseries}}

\let\specialsectionmark\@gobble
\let\specialsectionname\@empty
\def\l@specialsection{\@tocline{1}{0pt}{1pc}{}{\bfseries}}
\let\tocspecialsection\tocsection

\def\section{\@startsection{section}{1}%
  \z@{-1\linespacing\@plus-.75\linespacing}{.5\linespacing}%
  {\large\bfseries}}


\def\subsection{\@startsection{subsection}{2}%
  \z@{-.75\linespacing\@plus-.5\linespacing}{.5\linespacing}%
  {\normalfont\bfseries}}

\def\subsubsection{\@startsection{subsubsection}{3}%
   \z@{.5\linespacing\@plus.5\linespacing}{-5\p@}%
   {\normalfont\itshape}}

\def\th@plain{%
  \let\thm@indent\noindent
  \thm@headfont{\bfseries}% heading font bold
  \thm@notefont{\mdseries\upshape}
  \thm@preskip.5\baselineskip\@plus.2\baselineskip
                                    \@minus.2\baselineskip
  \thm@postskip\thm@preskip
  \itshape
}
\def\th@remark{%
  \let\thm@indent\noindent
  \thm@headfont{\bfseries}% heading font bold
  \thm@notefont{\mdseries\upshape}%
  \thm@preskip.5\baselineskip\@plus.2\baselineskip
                                    \@minus.2\baselineskip
  \thm@postskip\thm@preskip
  \upshape
}
\def\th@definition{%
  \let\thm@indent\noindent
  \thm@headfont{\bfseries}% heading font bold
  \thm@notefont{\mdseries\upshape}%
  \thm@preskip.5\baselineskip\@plus.2\baselineskip
                                    \@minus.2\baselineskip
  \thm@postskip\thm@preskip
  \upshape
}

\renewenvironment{proof}[1][\proofname]{\par \normalfont
  \topsep6\p@\@plus6\p@ \trivlist \itemindent\z@
  \item[\hskip\labelsep\bfseries
    #1\@addpunct{.}]\ignorespaces
}{%
  \qed\endtrivlist
}

\def\xcb{%
  \settowidth{\leftmargini}{0.\hskip\labelsep}%
  \settowidth{\leftmarginii}{(d.)\hskip\labelsep}%
\@startsection{section}% counter name; ignored because of the
                                % * below
{1}% sectioning level
{\z@}% indent to the left of the section title
{18\p@\@plus2\p@}% vertical space above *** added 12 more points space!!
{1sp}% Space below of 13pt base-to-base, so none needs to be added
    % here; but \z@ would cause the following text to be run-in, so we
    % use 1sp instead.
{\large\bfseries}% The font of the subsection title
*% always unnumbered
}%

%    correct the form of these commands from \...@ to \@... [bnb, 1997/01/02]
\def\@captionheadfont{\bfseries}
\def\@captionfont{\footnotesize\mdseries}

% run head & foot are bold.
\def\ps@plain{\ps@empty
  \def\@oddfoot{\normalfont\footnotesize\bfseries \hfil\thepage\hfil}%
  \let\@evenfoot\@oddfoot}

\def\ps@headings{\ps@empty
  \def\@evenhead{\normalfont\footnotesize\bfseries \let\\=\space
      \rlap{\thepage}\hfil \leftmark{}{}\hfil}%
  \def\@oddhead{\normalfont\footnotesize\bfseries \let\\=\space \hfil
      \rightmark{}{}\hfil \llap{\thepage}}%
  \let\@mkboth\markboth
  \def\partmark{\@secmark\markboth\partrunhead\partname}%
  \def\chaptermark{%
    \@secmark\markboth\chapterrunhead{}}%
  \def\sectionmark{%
    \@secmark\markright\sectionrunhead\sectionname}%
%    managing the marks for Lecture is a bit complicated
%  \let\lecturemark\sectionmark
  \def\lecturemark{%\let\@secnumber\@empty
%    \@secmark\markright\sectionrunhead\sectionname}%
    \@secmark\markright\lecturerunhead\chaptername}%
}

%    The following is for lecture opening pages.
\def\ps@firstpage{\ps@empty
  \def\@oddfoot{\normalfont\scriptsize \hfil\thepage\hfil
     \global\topskip\normaltopskip}%
  \let\@evenfoot\@oddfoot
  \def\@oddhead{\@serieslogo\hss}%
  \let\@evenhead\@oddhead}% in case an article starts on a left-hand page

%    Delay of these definitions is necessary to get around a similar delay
%    in amsproc, whereby if \cn{publname} is not yet defined, the logo will
%    be omitted, but if \cn{publname} is defined, the logo is defined then.
%    [bnb, 1996/11/06]
\AtBeginDocument{%
  \def\publname{IAS/Park City Mathematics Series}%
  \def\@serieslogo{\vtop to\z@{%
    \parindent\z@ \fontsize{8}{9\p@}\bfseries
        \publname\newline
        Volume \currentvolume, \currentyear\endgraf}%
  }%
}

\def\currentvolume{00}
\def\currentyear{0000}

%    Lectures require a copyright block at the bottom of the first page
%    of the first lecture.  This is not the usual monograph style, so
%    this code has been excerpted from amsproc.cls.  [bnb, 1996/10/22]
\def\copyrightyear{0000}
\newinsert\copyins
\skip\copyins=1.5pc
\count\copyins=1000 % magnification factor, 1000 = 100%
\dimen\copyins=.5\textheight % maximum allowed per page
\def\@setcopyright{%
  \insert\copyins{\hsize\textwidth
    \parfillskip\z@ \leftskip\z@\@plus.9\textwidth
    \fontsize{6}{7\p@}\normalfont\upshape
    \everypar{}%
    \vskip-\skip\copyins \nointerlineskip
    \noindent\vrule\@width\z@\@height\skip\copyins
    \copyright\copyrightyear\ elbauldelprogramador.com\par
    \kern\z@}%
}
\def\@combinefloats{%
  \ifx \@toplist\@empty \else \@cflt \fi
  \ifx \@botlist\@empty \else \@cflb \fi
  \ifvoid\copyins \else \@cflci \fi
}
\def\@cflci{%
  \if\if@twocolumn \if@firstcolumn F\else T\fi\else T\fi T%
      \setbox\@outputbox\vbox{%
        \unvbox\@outputbox
        \vskip\skip\copyins
        \hbox to\columnwidth{%
          \hss\vbox to\z@{\vss\unvbox\copyins}}}%
  \fi
}

\addresscount@=\z@
\def\setaddress{%
  {\let\@makefnmark\relax  \let\@thefnmark\relax
        \nobreak
        \addressnum@=\z@
        \loop\ifnum\addressnum@<\addresscount@\advance\addressnum@\@ne
           \footnote{$^{\hbox{\tiny\number\addressnum@}}$%
           \csname @address\number\addressnum@\endcsname
           \csname @curraddr\number\addressnum@\endcsname
           \csname @email\number\addressnum@\endcsname}\repeat
    }%
  \@setcopyright
}

\def\partrunhead#1#2#3{%
  \@ifnotempty{#2}{{#1 #2}\@ifnotempty{#3}{. }}%
  #3}
\let\sectionrunhead\partrunhead

\ifLecture
  \def\chapterrunhead#1#2#3{%
    \let\@tempa\@author
    \uppercasenonmath{\@tempa}%
    \uppercasenonmath{\thelectureseries}%
    \@tempa. \thelectureseries
    }
  \def\lecturerunhead#1#2#3{%
    \let\@tempa\chaptername
    \uppercasenonmath{\@tempa}%
    \def\@tempb{#3\unskip}%
    \uppercasenonmath{\@tempb}%
    \@tempa\ #2. \@tempb
    }
\else
  \let\chapterrunhead\partrunhead
\fi

%% altered \include to set Lecture false
%%  let's not -- there are better ways to do this!

%\def\include#1{\relax
%  \ifnum\@auxout=\@partaux
%    \@latex@error{\string\include\space cannot be nested}\@eha
%  \else \@include#1 \fi}
%\def\@include#1 {\clearpage\global\Lecturefalse\global\Monographtrue
%\if@filesw \immediate\write\@mainaux{\string\@input{#1.aux}}\fi
%\@tempswatrue \if@partsw\@tempswafalse\edef\@tempb{#1}\@for
%\@tempa:=\@partlist\do{\ifx\@tempa\@tempb\@tempswatrue\fi}\fi
%\if@tempswa \let\@auxout\@partaux \if@filesw
%\immediate\openout\@partaux #1.aux
%\immediate\write\@partaux{\relax}\fi\@input@{#1.tex}\clearpage
%\@writeckpt{#1}\if@filesw \immediate\closeout\@partaux \fi
%\else\@nameuse{cp@#1}\fi\let\@auxout\@mainaux}


%% alter backmatter to announce its presence, to permit a separate
%% bibliography in a lecture series to set up proper running heads

\newif\if@backmatter \@backmatterfalse
\def\backmatter{\cleardoublepage \@backmattertrue}


%
%
% this allows for user to have biblio print as either a chapter or
% as a section

\def\thebibliography#1{%
  \ifLecture
    \section*\refname
    \if@backmatter
      \markboth{\refname}{\refname}%
    \fi
  \else
    \chapter*\bibname
    \markboth{\bibname}{\bibname}%
  \fi
  \normalsize\labelsep .5em\relax
  \list{\@arabic\c@enumi.}{\settowidth\labelwidth{\@biblabel{#1}}%
  \leftmargin\labelwidth
  \advance\leftmargin\labelsep
	\bibsetup\relax
	\usecounter{enumi}}\sloppy
  \clubpenalty9999 \widowpenalty\clubpenalty  \sfcode`\.\@m}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      INDEX
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\theindex{\cleardoublepage
\@restonecoltrue\if@twocolumn\@restonecolfalse\fi
\columnseprule \z@ \columnsep 35pt
\def\indexchap{\@startsection
		{chapter}{1}{\z@}{8pc}{34pt}%
		{\raggedright
		\huge\bfseries}}%
 \twocolumn[\indexchap*{\indexname}]
 \@mkboth{{\indexname}}{{\indexname}}%
	\thispagestyle{plain}\let\item\@idxitem\parindent\z@
	 \footnotesize\parskip\z@ plus .3pt\relax\let\item\@idxitem}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      TOPMATTER
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\address#1{\global\advance\addresscount@\@ne
    \expandafter\gdef\csname @address\number\addresscount@\endcsname{%
	\noindent #1.}}

\def\curraddr#1{%
	\expandafter\gdef\csname @curraddr\number\addresscount@\endcsname{%
	\endgraf\noindent{\bf Current address}:\enspace #1.}}

\def\email#1{%
	\expandafter\gdef\csname @email\number\addresscount@\endcsname{%
	\endgraf\noindent{\bf E-mail address}:\enspace {\tt #1}.}}



\addresscount@=\z@
\def\@setaddresses{%
{  \let\@makefnmark\relax  \let\@thefnmark\relax
	\nobreak
	\addressnum@=\z@
	\loop\ifnum\addressnum@<\addresscount@\advance\addressnum@\@ne
	   \footnote{$^{\hbox{\tiny\number\addressnum@}}$%
	   \csname @address\number\addressnum@\endcsname
           \csname @curraddr\number\addressnum@\endcsname
           \csname @email\number\addressnum@\endcsname}\repeat
}}

\def\maketitle{\par
  \@topnum\z@ % this prevents figures from falling at the top of page 1
  \begingroup
  \@maketitle
  \endgroup
  \c@footnote\z@
  \def\do##1{\let##1\relax}%
  \do\maketitle \do\@maketitle \do\title \do\@xtitle \do\@title
  \do\author \do\@xauthor
  \do\dedicatory \do\@dedicatory
  \do\keywords \do\@keywords \do\subjclass \do\@subjclass
%    if this is a lecture, keep the original definitions for addresses,
%    so that they will be set in footnotes
  \ifLogoOn
  \else
     \do\address \do\@xaddress
     \do\email \do\@xemail \do\curraddr \do\@xcurraddr
     \do\thanks \do\thankses
  \fi
}

\def\@maketitle{\cleardoublepage \thispagestyle{empty}%
  \begingroup \topskip\z@skip
  \null\vfil
  \begingroup
  \begin{flushright}
  \huge\bfseries
  \openup\medskipamount
  \@title\endgraf
  \end{flushright}
  \vspace{24pt}%
  \def\and{\par\bigskip}%
  \begin{flushright}
  \LARGE\bfseries\authors
  \end{flushright}
  \endgroup
  \vfil
  \newpage\thispagestyle{empty}
  \ifx\@empty\addresses\else
  \@setaddresses\fi
    \ifx\@empty\@subjclass\else\@setsubjclass\fi
    \ifx\@empty\@translators\else\vfil\@settranslators\fi
    \ifx\@empty\thankses\else\vfil\@setthanks\fi
  \vfil
  \@setabstract
  \endgroup}

\endinput
