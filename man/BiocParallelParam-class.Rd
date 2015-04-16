\name{BiocParallelParam-class}
\Rdversion{1.1}
\docType{class}

% Class 
\alias{BiocParallelParam-class}
\alias{BiocParallelParam}

% Control
\alias{bpbackend}
\alias{bpbackend<-}
\alias{bpbackend,missing-method}
\alias{bpbackend<-,missing,ANY-method}
\alias{bpisup}
\alias{bpisup,ANY-method}
\alias{bpisup,missing-method}
\alias{bpstart}
\alias{bpstart,ANY-method}
\alias{bpstart,missing-method}
\alias{bpstop}
\alias{bpstop,ANY-method}
\alias{bpstop,missing-method}
\alias{bpworkers}
\alias{bpworkers,missing-method}
\alias{bpworkers,BiocParallelParam-method}
\alias{bptasks}
\alias{bptasks,BiocParallelParam-method}
\alias{bptasks<-}
\alias{bptasks<-,BiocParallelParam,numeric-method}
\alias{bpcatchErrors}
\alias{bpcatchErrors,BiocParallelParam-method}
\alias{bpcatchErrors<-}
\alias{bpcatchErrors<-,BiocParallelParam,logical-method}
\alias{bpstopOnError}
\alias{bpstopOnError,BiocParallelParam-method}
\alias{bpstopOnError<-}
\alias{bpstopOnError<-,BiocParallelParam,logical-method}

% Other methods
\alias{show,BiocParallel-method}


\title{BiocParallelParam objects}

\description{

  The \code{BiocParallelParam} virtual class stores configuration parameters
  for parallel execution. Concrete subclasses include \code{SnowParam}, 
  \code{MulticoreParam}, \code{BatchJobsParam}, and \code{DoparParam}
  and \code{SerialParam}.

}

\details{

  \code{BiocParallelParam} is the virtual base class on which other
  parameter objects build. There are 5 concrete subclasses:

  \describe{
      \item{}{\code{SnowParam}: distributed memory computing}
      \item{}{\code{MulticoreParam}: shared memory computing}
      \item{}{\code{BatchJobsParam}: scheduled cluster computing}
      \item{}{\code{DoparParam}: foreach computing}
      \item{}{\code{SerialParam}: non-parallel execution}
  }

  The parameter objects hold configuration parameters related to the 
  method of parallel execution such as shared memory, independent
  memory or computing with a cluster scheduler.

}

\section{Construction}{

  The \code{BiocParallelParam} class is virtual and has no constructor. 
  Instances of the subclasses can be created with the following:

  \itemize{
    \item \code{SnowParam()}
    \item \code{MulticoreParam()}
    \item \code{BatchJobsParam()}
    \item \code{DoparParam()}
    \item \code{SerialParam()}
  }

}

\section{Accessors}{

  \subsection{Back-end control}{
    In the code below \code{BPPARAM} is a \code{BiocParallelParam} object.

    \describe{
      \item{}{
        \code{bpworkers(x, ...)}:
        \code{integer(1)} or \code{character()}. Gets the number or names of 
        the back-end workers.
      }
      \item{}{
        \code{bptasks(x, ...)}, \code{bptasks(x) <- value}:
        \code{integer(1)}. Get or set the number of tasks for a job. \code{value}
        must be a scalar integer >= 0L. This argument applies
        to \code{SnowParam} and \code{MulticoreParam} only; \code{DoparParam}
        and \code{BatchJobsParam} have their own approach to dividing a job
        among workers. 
 
        In this documentation a job is defined as a single call to a function,
        \code{bplapply}, \code{bpmapply} etc. A task is the division of the
        \code{X} argument into chunks. When \code{tasks == 0} (default),
        \code{X} is divided by the number of workers. This approach distributes
        \code{X} in (approximately) equal chunks.
 
        A \code{tasks} value of > 0 dictates the total number of tasks. Values
        can range from 1 (all of \code{X} to a single worker) to the length of 
        \code{X} (each element of \code{X} to a different worker). 
 
        When the length of \code{X} is less than the number of workers each
        element of \code{X} is sent to a worker and \code{tasks} is ignored.
      }
      \item{}{
        \code{bpstart(x, ...)}:
        \code{logical(1)}. Starts the back-end, if necessary.
      }
      \item{}{
        \code{bpstop(x, ...)}:
        \code{logical(1)}. Stops the back-end, if necessary and possible.
      }
      \item{}{
        \code{bpisup(x, ...)}:
        \code{logical(1)}. Tests whether the back-end is available for processing,
        returning a scalar logical value. \code{bp*} functions such as
        \code{bplapply} automatically start the back-end if necessary.
      }
      \item{}{
        \code{bpbackend(x, ...)}, \code{bpbackend(x) <- value}: 
        Gets or sets the parallel \code{bpbackend}. Not all back-ends can
        be retrieved; see \code{showMethods("backend")}.
      }
    }
  }

  \subsection{Error Handling}{
    In the code below \code{BPPARAM} is a \code{BiocParallelParam} object.

    \describe{
      \item{}{
        \code{bpcatchErrors(x, ...)}, \code{bpcatchErrors(x) <- value}: 
        Get or set the flag to determine if apply-like functions quit with an
        error as soon as one application fails.  See ?\code{SnowParam} and
        ?\code{BatchJobsParam} for details applicable to each class.
      }
      \item{}{
        \code{bpstopOnError(x, ...)}, \code{bpstopOnError(x) <- value}: 
        Get or set the flag to determine if all jobs should be stopped as
        soon as one fails or if all should be attempted.
      }
    }
  }

}

\section{Methods}{

  \subsection{Evaluation}{
    In the code below \code{BPPARAM} is a \code{BiocParallelParam} object.
    Full documentation for these functions are on separate man pages: see
    ?\code{bpmapply}, ?\code{bplapply}, ?\code{bpvec}, ?\code{bpiterate} and
    ?\code{bpaggregate}.

    \describe{
      \item{}{
        \code{bpmapply(FUN, ..., MoreArgs=NULL, SIMPLIFY=TRUE, USE.NAMES=TRUE,
                       BPRESUME=getOption("BiocParallel.BPRESUME", FALSE), 
                       BPPARAM=bpparam())}
      }
      \item{}{
        \code{bplapply(X, FUN, ..., 
                       BPRESUME = getOption("BiocParallel.BPRESUME", FALSE),
                       BPPARAM=bpparam())}
      }
      \item{}{
        \code{bpvec(X, FUN, ..., AGGREGATE=c, BPPARAM=bpparam())}
      }
      \item{}{
        \code{bpiterate(ITER, FUN, ..., BPPARAM=bpparam())}
      }
      \item{}{
        \code{bpaggregate(x, data, FUN, ..., BPPARAM=bpparam())}
      }
    }
  }

  \subsection{Other}{
    In the code below \code{BPPARAM} is a \code{BiocParallelParam} object.

    \describe{
      \item{}{
        \code{show(x)}
      }
    }
  }

}

\author{Martin Morgan and Valerie Obenchain.}

\seealso{

  \itemize{
    \item \code{\link{SnowParam}} for computing in distributed memory

    \item \code{\link{MulticoreParam}} for computing in shared memory

    \item \code{\link{BatchJobsParam}} for computing with cluster schedulers

    \item \code{\link{DoparParam}} for computing with foreach

    \item \code{\link{SerialParam}} for non-parallel execution
  }

}

\examples{

getClass("BiocParallelParam")

## For examples see ?SnowParam, ?MulticoreParam, ?BatchJobsParam 
## and ?SerialParam.
}

\keyword{classes}
\keyword{methods}