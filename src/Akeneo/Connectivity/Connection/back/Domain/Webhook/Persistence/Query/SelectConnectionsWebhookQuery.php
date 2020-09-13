<?php

declare(strict_types=1);

namespace Akeneo\Connectivity\Connection\Domain\Webhook\Persistence\Query;

use Akeneo\Connectivity\Connection\Domain\Webhook\Model\Read\ConnectionWebhook;

interface SelectConnectionsWebhookQuery
{
    /**
     * @return ConnectionWebhook[]
     */
    public function execute(): array;
}
