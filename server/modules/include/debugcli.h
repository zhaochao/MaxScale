#ifndef _DEBUGCLI_H
#define _DEBUGCLI_H
/*
 *
 * Copyright (c) 2016 MariaDB Corporation Ab
 *
 * Use of this software is governed by the Business Source License included
 * in the LICENSE.TXT file and at www.mariadb.com/bsl.
 *
 * Change Date: 2019-01-01
 *
 * On the date above, in accordance with the Business Source License, use
 * of this software will be governed by version 2 or later of the General
 * Public License.
 */
#include <service.h>
#include <session.h>
#include <spinlock.h>

/**
 * @file debugcli.h The debug interface to the gateway
 *
 * @verbatim
 * Revision History
 *
 * Date     Who     Description
 * 18/06/13 Mark Riddoch    Initial implementation
 *
 * @endverbatim
 */
struct cli_session;

/**
 * The CLI_INSTANCE structure. There is one instane of the CLI "router" for
 * each service that uses the CLI.
 */
typedef struct cli_instance
{
    SPINLOCK    lock;       /*< The instance spinlock */
    SERVICE     *service;   /*< The debug cli service */
    int     mode;       /*< CLI interface mode */
    struct cli_session
        *sessions;  /*< Linked list of sessions within this instance */
    struct cli_instance
        *next;      /*< The next pointer for the list of instances */
} CLI_INSTANCE;

/**
 * The CLI_SESSION structure. As CLI_SESSION is created for each user that logs into
 * the DEBUG CLI.
 */
enum { cmdbuflen = 80 };

typedef struct cli_session
{
    char        cmdbuf[cmdbuflen]; /*< The command buffer used to build up user commands */
    int     mode;          /*< The CLI Mode for this session */
    SESSION     *session;      /*< The gateway session */
    struct cli_session
        *next;         /*< The next pointer for the list of sessions */
} CLI_SESSION;

/* Command line interface modes */
#define CLIM_USER       1
#define CLIM_DEVELOPER      2
#endif
