# transponder

![Version: 2.4.2](https://img.shields.io/badge/Version-2.4.2-informational?style=flat-square) ![AppVersion: 0.23.16](https://img.shields.io/badge/AppVersion-0.23.16-informational?style=flat-square)

Ketch Transponder

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Ketch Support | <support@ketch.com> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.image.tag | string | Defaults to AppVersion in Chart.yaml | What tagged version of the docker image you want deployed |
| global.image.pullPolicy | string | `"IfNotPresent"` | What docker image pull policy do you want? |
| global.imagePullSecrets | list | `[]` | Any additional imagePullSecrets to be used |
| global.vpa | object | `{"enabled":false}` | [DEPRECATED] VPA is no longer in use. This whole section will be removed in the next major version. |
| global.podDisruptionBudget.enabled | bool | `true` | Specifies whether a pod disruption budget should be used |
| global.podDisruptionBudget.minAvailable | string | `"50%"` | Minimum number/percentage of pods that should remain scheduled |
| global.podDisruptionBudget.maxUnavailable | string | `""` | Maximum number/percentage of pods that may be made unavailable |
| global.service.annotations | object | `{}` | Annotations to be added to the service |
| global.serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| global.serviceAccount.annotations | object | `{}` | Annotations to be added to the service account |
| commonLabels | object | `{}` | Labels to be added to all deployed resources |
| commonAnnotations | object | `{}` | Annotations to be added to all deployed resources |
| extraEnvVars | list | `[]` | Extra environment variables to be added to all deployments |
| extraVolumes | list | `[]` | Extra volumes to be added to all deployments |
| extraVolumeMounts | list | `[]` | Extra volume mounts to be added to all deployments |
| config.org | string | `""` | [DEPRECATED] Organization code is no longer in use. This field will be removed in the next major version. |
| config.id | string | `""` | [Required] What is the ID of Transponder.  This is to identify the transponder.    This commonly reflects the location or environment that the transponder is deployed into.    Only lower case alphabet, numbers, and `_` are valid characters for this ID. |
| config.transponder.resources | object | `{"limits":{"cpu":"2","memory":"2Gi"},"requests":{"cpu":"1","memory":"1Gi"}}` | Resource limits and requests |
| config.transponder.replica | int | `2` | How many Transponder pods to run |
| config.transponder.service.annotations | object | `{}` | Annotations to be added to the service |
| config.transponder.service.type | string | `"NodePort"` | Type of the service The default value will change to `ClusterIP` in the next major version |
| config.transponder.service.port | int | `443` | Port that this service exposes |
| config.transponder.service.loadBalancerSourceRanges | list | `[]` | Addresses that are allowed when service is LoadBalancer |
| config.transponder.serviceAccount.name | string | A generated name using the fullname template | The name of the service account to use |
| config.transponder.serviceAccount.annotations | object | `{}` | Annotations to be added to the service account |
| config.transponder.podLabels | object | `{}` | Extra labels to be added to the Transponder pods |
| config.transponder.podAnnotations | object | `{}` | Extra annotations to be added to the Transponder pods |
| config.transponder.extraEnvVars | list | `[]` | Extra environment variables to be added to the Transponder deployment |
| config.transponder.extraVolumes | list | `[]` | Extra volumes to be added to the Transponder deployment |
| config.transponder.extraVolumeMounts | list | `[]` | Extra volume mounts to be added to the Transponder deployment |
| config.sonar.enabled | bool | `true` | Specifies whether the agent component should be used |
| config.sonar.interval | int | `60` | Number of seconds between checking for new work |
| config.sonar.storage.class | string | `""` | Which storage class should be used? If left empty, the default storage class will be used. |
| config.sonar.resources | object | `{"limits":{"cpu":"2","memory":"2Gi"},"requests":{"cpu":"1","memory":"1Gi"}}` | Resource limits and requests |
| config.sonar.replica | int | `2` | How many Sonar pods to run |
| config.sonar.service.annotations | object | `{}` | Annotations to be added to the service |
| config.sonar.service.type | string | `"NodePort"` | Type of the service The default value will change to `ClusterIP` in the next major version |
| config.sonar.service.port | int | `443` | Port that this service exposes |
| config.sonar.service.loadBalancerSourceRanges | list | `[]` | Addresses that are allowed when service is LoadBalancer |
| config.sonar.serviceAccount.name | string | A generated name using the fullname template | The name of the service account to use |
| config.sonar.serviceAccount.annotations | object | `{}` | Annotations to be added to the service account |
| config.sonar.podLabels | object | `{}` | Extra labels to be added to the Sonar pods |
| config.sonar.podAnnotations | object | `{}` | Extra annotations to be added to the Sonar pods |
| config.sonar.extraEnvVars | list | `[]` | Extra environment variables to be added to the Sonar deployment |
| config.sonar.extraVolumes | list | `[]` | Extra volumes to be added to the Sonar deployment |
| config.sonar.extraVolumeMounts | list | `[]` | Extra volume mounts to be added to the Sonar deployment |
| config.tls.override | string | `"transponder"` | Override the TLS server name. This should match your TLS certificate |
| config.tls.cert.content | string | `""` | The base64 encoded TLS certificate. |
| config.tls.key.content | string | `""` | The base64 encoded TLS key. |
| config.tls.rootca.content | string | `""` | The base64 encoded TLS root CA. |
| config.vault.enabled | bool | `false` | [DEPRECATED] Use .secret.provider instead. This field will be removed in the next major version. |
| config.aws.region | string | `"us-west-2"` | AWS Region.  Used for populating the AWS_DEFAULT_REGION environment variable |
| config.aws.keyId | string | `""` | AWS access key.  Used for AWS Secrets Manager |
| config.aws.secretKey | string | `""` | AWS secret access key.  Used for AWS Secrets Manager |
| config.aws.secretsManager.enabled | bool | `true` | [DEPRECATED] Use .secret.provider instead. This field will be removed in the next major version. |
| config.aws.secretsManager.prefix | string | `"ketch"` | Prefix to use; all secrets will be created under this prefix |
| config.azure.vaultURI | string | `""` | Vault URI of the Key Vault |
| config.azure.prefix | string | `"ketch"` | Prefix to use; all secrets will be created under this prefix |
| config.azure.tenantID | string | `""` | Directory/Tenant ID of the app registration |
| config.azure.client.id | string | `""` | Application/Client ID of the app registration |
| config.azure.client.secret | string | `""` | Application/Client secret of the app registration |
| config.googleSecretsManager.projectID | string | `""` | Google Secrets Manager project ID |
| config.googleSecretsManager.prefix | string | `"ketch"` | Prefix to use; all secrets will be created under this prefix |
| config.googleSecretsManager.secret | object | `{"key":"","name":""}` | Kubernetes secret to use for the service account credentials for Google Cloud Platform |
| config.googleSecretsManager.secret.name | string | `""` | Name of the Kubernetes secret in which the service account credentials are stored |
| config.googleSecretsManager.secret.key | string | `""` | Key of the Kubernetes secret in which the service account credentials are stored |
| config.googleSecretsManager.key | string | `""` | JSON key of the service account for Google Cloud Platform |
| secret.provider | string | `""` | Which secret providers to use (either 'awsSecretsManager', 'vault', 'azureKeyVault', or 'googleSecretsManager') |
| ingress.enabled | bool | `true` | Enable ingress |
| ingress.hostname | string | `"transponder"` | Name of the host under this ingress |
| ingress.annotations | object | `{}` | Annotations to apply to the ingress |
| ingress.class | string | `""` | Ingress Class to be used |
| ingress.tls | bool | `true` | Enable TLS configuration for the hostname defined at `ingress.hostname` parameter |
| ingress.extraTLS | list | `[]` | The additional tls configurations to be covered with this ingress record. |
| imageCredentials.enabled | bool | `true` | Enable imagePullSecret |
| imageCredentials.registry | string | `"https://ketch.jfrog.io/"` | What Docker registry is your docker container located at? |
| imageCredentials.username | string | `""` | Username to use for image registry. This is found at the Create Transponder page, under the Ketch repository User Name. |
| imageCredentials.password | string | `""` | Password to use for image registry. This is found at the Create Transponder page, under the Ketch repository Key. |
| metrics.serviceMonitor.enabled | bool | `false` | Enable prometheus-operator serviceMonitor |
| metrics.serviceMonitor.interval | string | `"15s"` | How often to scrape the metrics endpoints |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | A generated name using the fullname template | The name of the service account to use |
| serviceAccount.annotations | object | `{}` | Annotations to be added to the service account |

