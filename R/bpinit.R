.bpinit <-
    function(manager, FUN, BPPARAM, ...)
{
    ## Conditions for starting a cluster, or falling back to (and
    ## starting) a SerialParam
    nworkers <- bpnworkers(BPPARAM) # cache in case this requires a netowrk call
    fallback_condition <-
        !inherits(BPPARAM, "SerialParam") &&
        nworkers == 0L ||    # e.g., in dynamic cluster like RedisParam
        !bpschedule(BPPARAM) # e.g., in nested parallel call
    if (!bpisup(BPPARAM) || fallback_condition) {
        if (fallback_condition || nworkers == 1L) {
            ## use SerialParam when zero workers (e.g., in a dynaamic
            ## cluster like RedisParam, where there are no registered
            ## workers), or when bpschedule() is FALSE (e.g,. because
            ## we are already in a parallel job), or when there is
            ## only one worker (when the cost of serialization to a
            ## remote worker can be avoided).
            oldParam <- BPPARAM
            BPPARAM <- as(BPPARAM, "SerialParam")
            on.exit({
                .RNGstream(oldParam) <- .RNGstream(BPPARAM)
            }, TRUE, FALSE) # add = TRUE, last = FALSE --> last in,
                            # first out order
        } else if (is(BPPARAM, "MulticoreParam")) {
            ## use TransientMulticoreParam when MulticoreParam has not
            ## started
            oldParam <- BPPARAM
            BPPARAM <- as(BPPARAM, "TransientMulticoreParam")
            on.exit({
                .RNGstream(oldParam) <- .RNGstream(BPPARAM)
            }, TRUE, FALSE)
        }

        ## start / stop cluster
        BPPARAM <- bpstart(BPPARAM)
        on.exit(bpstop(BPPARAM), TRUE, FALSE)
    }

    ## FUN
    FUN <- .composeTry(
        FUN, bplog(BPPARAM), bpstopOnError(BPPARAM),
        timeout=bptimeout(BPPARAM), exportglobals=bpexportglobals(BPPARAM),
        force.GC = bpforceGC(BPPARAM)
    )

    ## iteration
    res <- bploop(
        manager, # dispatch
        FUN = FUN,
        BPPARAM = BPPARAM,
        ...
    )
    res
}
