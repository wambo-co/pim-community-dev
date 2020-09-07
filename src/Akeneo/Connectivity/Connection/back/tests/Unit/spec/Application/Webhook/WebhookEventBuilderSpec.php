<?php
declare(strict_types=1);

namespace spec\Akeneo\Connectivity\Connection\Application\Webhook;

use Akeneo\Connectivity\Connection\Application\Webhook\WebhookEventBuilder;
use Akeneo\Connectivity\Connection\Application\Webhook\WebhookEventBuilderRegistry;
use Akeneo\Connectivity\Connection\Domain\Webhook\Model\ConnectionWebhook;
use Akeneo\Connectivity\Connection\Domain\Webhook\Model\WebhookEvent;
use Akeneo\Platform\Component\EventQueue\BusinessEventInterface;
use PhpSpec\ObjectBehavior;

/**
 * @author    Thomas Galvaing <thomas.galvaing@akeneo.com>
 * @copyright 2020 Akeneo SAS (http://www.akeneo.com)
 * @license   http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
 */
class WebhookEventBuilderSpec extends ObjectBehavior
{
    public function let(WebhookEventBuilderRegistry $dataBuilderRegistry): void
    {
        $this->beConstructedWith($dataBuilderRegistry);
    }

    public function it_is_initializable(): void
    {
        $this->shouldBeAnInstanceOf(WebhookEventBuilder::class);
    }

    public function it_builds_webhook_event($dataBuilderRegistry)
    {
        $webhook = new ConnectionWebhook('bynder',7, 'secret_bynder','http://172.17.0.1:8000/webhook');
        $businessEvent = new BusinessEvent();

        $dataBuilderRegistry->build($webhook, $businessEvent)->willReturn([]);
        $webhookEvent = $this->build($webhook, $businessEvent);
        $webhookEvent->shouldBeAnInstanceOf(WebhookEvent::class);
        $webhookEvent->action()->shouldBe($businessEvent->name());
        $webhookEvent->eventId()->shouldBe($businessEvent->uuid());
        $webhookEvent->eventDate()->shouldBe(date(\DateTimeInterface::ATOM, $businessEvent->timestamp()));
        $webhookEvent->data()->shouldBe($businessEvent->data());
    }
}

class BusinessEvent implements BusinessEventInterface
{
    public function name(): string
    {
        return 'product.updated';
    }

    public function author(): string
    {
        return 'magento_connection';
    }

    public function data(): array
    {
        return [];
    }

    public function timestamp(): int
    {
        return 123456;
    }

    public function uuid(): string
    {
        return 'UUID';
    }
}
