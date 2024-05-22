{
  "title": "Cost of a team/project in Kubernetes",
  "description": "",
  "widgets": [
    {
      "id": 4120608610784570,
      "definition": {
        "type": "note",
        "content": "About\n=======\n\nOur current tools do not allow us to monitor our Kubernetes costs.\n\nThe challenge in Kubernetes is that we know how much our base infrastructure costs (i.e. the virtual machines running the show), but we don't have an accurate way of knowing how much a certain team or project has contributed to them (i.e. the cost of a pod).\n\nThe cost of each project is a function of the resources allocated to it. Namely: CPU, memory, disk, cost/hour of the instance type where it's deployed...\n\nThis dashboard is a naive approximation that takes into account\n\n```\nA: (cpu allocated to a team or project / total capacity of the cluster)\nB: (memory allocated to a team or project / total capacity of the cluster)\nC: mean(A, B)\nD: cumulative_sum(C) * actual or forecasted spending this month\n```\n\nWhere possible, it also aims to provide visibility on the gap between the actual costs and the optimal costs (costs if the project was 100% resource-efficient)\n",
        "background_color": "white",
        "font_size": "14",
        "text_align": "left",
        "show_tick": false,
        "tick_pos": "50%",
        "tick_edge": "left"
      }
    },
    {
      "id": 4902804732973964,
      "definition": {
        "type": "note",
        "content": "Quick Usage Tips\n===============\n\n* Budgets have a monthly cycle. Every month, the spending will drop to 0 and start accumulating again. Therefore, __we recommend that you choose a time window that focuses on a specific month__ (e.g. March 1st to March 31st).\n* Use the \"Save or select views\" drop-down at the top of the dashboard to change between production and stage.\n* Use the \"team\" and \"project\" drop-downs at the top of the dashboard to filter the information you see.\n",
        "background_color": "white",
        "font_size": "14",
        "text_align": "left",
        "show_tick": false,
        "tick_pos": "50%",
        "tick_edge": "left"
      }
    },
    {
      "id": 8011189877078990,
      "definition": {
        "title": "Actual and forecasted spending (globally)",
        "title_size": "16",
        "title_align": "left",
        "show_legend": false,
        "type": "timeseries",
        "requests": [
          {
            "q": "avg:aws.billing.actual_spend{$budget}, avg:aws.billing.forecasted_spend{$budget}",
            "style": {
              "palette": "dog_classic",
              "line_type": "solid",
              "line_width": "normal"
            },
            "display_type": "line"
          }
        ],
        "yaxis": {
          "scale": "linear",
          "include_zero": true,
          "min": "auto",
          "max": "auto"
        }
      }
    },
    {
      "id": 2369699414904310,
      "definition": {
        "title": "Team spending",
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 7597839744214140,
            "definition": {
              "title": "Total spending by team ($)",
              "type": "toplist",
              "requests": [
                {
                  "q": "top(((cumsum(sum:kubernetes.memory.requests{$cluster,$team} by {team})/cumsum(sum:kubernetes_state.node.memory_capacity{$cluster})+cumsum(sum:kubernetes.cpu.requests{$cluster,$team} by {team})/cumsum(sum:kubernetes_state.node.cpu_capacity{$cluster}))/2)*avg:aws.billing.actual_spend{$budget},25,'max','desc')"
                }
              ]
            }
          },
          {
            "id": 3539889707341843,
            "definition": {
              "title": "Evolution of spending by team ($)",
              "show_legend": false,
              "type": "timeseries",
              "requests": [
                {
                  "q": "((cumsum(sum:kubernetes.memory.requests{$cluster,$team} by {team})/cumsum(sum:kubernetes_state.node.memory_capacity{$cluster})+cumsum(sum:kubernetes.cpu.requests{$cluster,$team} by {team})/cumsum(sum:kubernetes_state.node.cpu_capacity{$cluster}))/2)*avg:aws.billing.actual_spend{$budget}",
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "scale": "linear",
                "include_zero": true,
                "min": "auto",
                "max": "auto"
              }
            }
          },
          {
            "id": 118298876856371,
            "definition": {
              "title": "Forecasted spending by team ($) by the end of the month",
              "type": "toplist",
              "requests": [
                {
                  "q": "top(((cumsum(sum:kubernetes.memory.requests{$cluster,$team} by {team})/cumsum(sum:kubernetes_state.node.memory_capacity{$cluster})+cumsum(sum:kubernetes.cpu.requests{$cluster,$team} by {team})/cumsum(sum:kubernetes_state.node.cpu_capacity{$cluster}))/2)*avg:aws.billing.forecasted_spend{$budget},25,'max','desc')"
                }
              ]
            }
          },
          {
            "id": 8283094138193034,
            "definition": {
              "title": "Potential monthly savings if capacity == usage at all times ($)",
              "type": "toplist",
              "requests": [
                {
                  "q": "top(((((cumsum(sum:kubernetes.memory.requests{$cluster,$team} by {team})-cumsum(sum:kubernetes.memory.usage{$cluster,$team} by {team}))/cumsum(sum:kubernetes_state.node.memory_capacity{$cluster}))+((cumsum(sum:kubernetes.cpu.requests{$cluster,$team} by {team})-cumsum(sum:kubernetes.cpu.user.total{$cluster,$team} by {team}))/cumsum(sum:kubernetes_state.node.cpu_capacity{$cluster})))/2)*avg:aws.billing.forecasted_spend{$budget},25,'max','desc')"
                }
              ]
            }
          }
        ]
      }
    },
    {
      "id": 8060375921688648,
      "definition": {
        "title": "Project spending",
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 5420251994543078,
            "definition": {
              "title": "Total spending by project ($)",
              "type": "toplist",
              "requests": [
                {
                  "q": "top(((cumsum(sum:kubernetes.memory.requests{$cluster,$team,$project} by {project})/cumsum(sum:kubernetes_state.node.memory_capacity{$cluster})+cumsum(sum:kubernetes.cpu.requests{$cluster,$team,$project} by {project})/cumsum(sum:kubernetes_state.node.cpu_capacity{$cluster}))/2)*avg:aws.billing.actual_spend{$budget},25,'max','desc')"
                }
              ]
            }
          },
          {
            "id": 6626266442035335,
            "definition": {
              "title": "Evolution of spending by project ($)",
              "show_legend": false,
              "type": "timeseries",
              "requests": [
                {
                  "q": "((cumsum(sum:kubernetes.memory.requests{$cluster,$team,$project} by {project})/cumsum(sum:kubernetes_state.node.memory_capacity{$cluster})+cumsum(sum:kubernetes.cpu.requests{$cluster,$team,$project} by {project})/cumsum(sum:kubernetes_state.node.cpu_capacity{$cluster}))/2)*avg:aws.billing.actual_spend{$budget}",
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "scale": "linear",
                "include_zero": true,
                "min": "auto",
                "max": "auto"
              }
            }
          },
          {
            "id": 4357526745945324,
            "definition": {
              "title": "Forecasted spending by project ($) at the end of the month",
              "type": "toplist",
              "requests": [
                {
                  "q": "top(((cumsum(sum:kubernetes.memory.requests{$cluster,$team,$project} by {project})/cumsum(sum:kubernetes_state.node.memory_capacity{$cluster})+cumsum(sum:kubernetes.cpu.requests{$cluster,$team,$project} by {project})/cumsum(sum:kubernetes_state.node.cpu_capacity{$cluster}))/2)*avg:aws.billing.forecasted_spend{$budget},25,'max','desc')"
                }
              ]
            }
          },
          {
            "id": 3780550225682313,
            "definition": {
              "title": "Potential monthly savings if capacity == usage at all times ($)",
              "type": "toplist",
              "requests": [
                {
                  "q": "top(((((cumsum(sum:kubernetes.memory.requests{$cluster,$team,$project} by {project})-cumsum(sum:kubernetes.memory.usage{$cluster,$team,$project} by {project}))/cumsum(sum:kubernetes_state.node.memory_capacity{$cluster}))+((cumsum(sum:kubernetes.cpu.requests{$cluster,$team,$project} by {project})-cumsum(sum:kubernetes.cpu.user.total{$cluster,$team,$project} by {project}))/cumsum(sum:kubernetes_state.node.cpu_capacity{$cluster})))/2)*avg:aws.billing.forecasted_spend{$budget},25,'max','desc')"
                }
              ]
            }
          }
        ]
      }
    },
    {
      "id": 7092820063616597,
      "definition": {
        "title": "CPU Inefficiencies",
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 5905262213084909,
            "definition": {
              "title": "Idle CPU (avg for the whole cluster)",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "q": "100-(sum:kubernetes.cpu.usage.total{$cluster}/1000000000)*100/sum:kubernetes.cpu.capacity{$cluster}",
                  "aggregator": "avg",
                  "conditional_formats": [
                    {
                      "hide_value": false,
                      "comparator": ">=",
                      "palette": "white_on_red",
                      "value": 70
                    },
                    {
                      "hide_value": false,
                      "comparator": "<",
                      "palette": "white_on_yellow",
                      "value": 70
                    },
                    {
                      "hide_value": false,
                      "comparator": "<=",
                      "palette": "white_on_green",
                      "value": 20
                    }
                  ]
                }
              ],
              "autoscale": true,
              "custom_unit": "%",
              "precision": 1
            }
          },
          {
            "id": 5167077829794877,
            "definition": {
              "title": "CPU requests out of total capacity (%)",
              "type": "toplist",
              "requests": [
                {
                  "q": "top(sum:kubernetes.cpu.requests{$cluster,$team,$project} by {project}/sum:kubernetes_state.node.cpu_capacity{$cluster},25,'mean','desc')"
                }
              ]
            }
          },
          {
            "id": 6088326047470561,
            "definition": {
              "title": "Most inefficient projects by CPU utilization (%)",
              "type": "toplist",
              "requests": [
                {
                  "q": "top(avg:kubernetes.cpu.user.total{kube_container_name:main,$cluster,$project,$team} by {project}/avg:kubernetes.cpu.requests{kube_container_name:main,$cluster,$project,$team} by {project}*100,25,'mean','asc')",
                  "conditional_formats": [
                    {
                      "hide_value": false,
                      "comparator": "<=",
                      "palette": "white_on_red",
                      "value": 20
                    },
                    {
                      "hide_value": false,
                      "comparator": "<=",
                      "palette": "white_on_yellow",
                      "value": 30
                    },
                    {
                      "hide_value": false,
                      "comparator": ">=",
                      "palette": "white_on_green",
                      "value": 30
                    }
                  ]
                }
              ]
            }
          },
          {
            "id": 6294160121756413,
            "definition": {
              "title": "Projects with the biggest CPU slack (# of cores used vs requested)",
              "type": "toplist",
              "requests": [
                {
                  "q": "top(avg:kubernetes.cpu.requests{kube_container_name:main,$cluster,$team,$project} by {project}-avg:kubernetes.cpu.user.total{kube_container_name:main,$cluster,$team,$project} by {project},25,'mean','desc')",
                  "conditional_formats": [
                    {
                      "hide_value": false,
                      "comparator": "<=",
                      "palette": "white_on_green",
                      "value": 0.3
                    },
                    {
                      "hide_value": false,
                      "comparator": "<=",
                      "palette": "white_on_yellow",
                      "value": 1
                    },
                    {
                      "hide_value": false,
                      "comparator": ">=",
                      "palette": "white_on_red",
                      "value": 1
                    }
                  ]
                }
              ]
            }
          }
        ]
      }
    },
    {
      "id": 7908999028156,
      "definition": {
        "title": "Memory Inefficiencies",
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 6908755368599561,
            "definition": {
              "title": "Idle Memory (avg for the whole cluster)",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "q": "100-sum:kubernetes.memory.usage{$cluster}/sum:kubernetes.memory.capacity{$cluster}*100",
                  "aggregator": "avg",
                  "conditional_formats": [
                    {
                      "hide_value": false,
                      "comparator": ">",
                      "palette": "white_on_red",
                      "value": 70
                    },
                    {
                      "hide_value": false,
                      "comparator": "<=",
                      "palette": "white_on_yellow",
                      "value": 70
                    },
                    {
                      "hide_value": false,
                      "comparator": "<",
                      "palette": "white_on_green",
                      "value": 30
                    }
                  ]
                }
              ],
              "autoscale": false,
              "custom_unit": "%",
              "precision": 0
            }
          },
          {
            "id": 6704808208661826,
            "definition": {
              "title": "Memory requests out of total capacity (%)",
              "type": "toplist",
              "requests": [
                {
                  "q": "top(sum:kubernetes.memory.requests{$cluster,$team,$project} by {project}/sum:kubernetes_state.node.memory_capacity{$cluster},25,'mean','desc')"
                }
              ]
            }
          },
          {
            "id": 1428268968026934,
            "definition": {
              "title": "Most inefficient projects by memory utilization (%)",
              "type": "toplist",
              "requests": [
                {
                  "q": "top(avg:kubernetes.memory.usage_pct{kube_container_name:main,$cluster,$project,$team} by {project}*100,25,'mean','asc')",
                  "conditional_formats": [
                    {
                      "hide_value": false,
                      "comparator": "<=",
                      "palette": "white_on_red",
                      "value": 50
                    },
                    {
                      "hide_value": false,
                      "comparator": "<=",
                      "palette": "white_on_yellow",
                      "value": 70
                    },
                    {
                      "hide_value": false,
                      "comparator": ">=",
                      "palette": "white_on_green",
                      "value": 70
                    }
                  ]
                }
              ]
            }
          },
          {
            "id": 2736391335470193,
            "definition": {
              "title": "Projects with the biggest memory slack (GBs used vs requested)",
              "type": "toplist",
              "requests": [
                {
                  "q": "top((avg:kubernetes.memory.requests{kube_container_name:main,$cluster,$project,$team} by {project}-max:kubernetes.memory.usage{kube_container_name:main,$cluster,$project,$team} by {project})/1000000000,10,'mean','desc')",
                  "conditional_formats": [
                    {
                      "hide_value": false,
                      "comparator": "<=",
                      "palette": "white_on_green",
                      "value": 1.5
                    },
                    {
                      "hide_value": false,
                      "comparator": "<",
                      "palette": "white_on_yellow",
                      "value": 2.5
                    },
                    {
                      "hide_value": false,
                      "comparator": ">=",
                      "palette": "white_on_red",
                      "value": 2.5
                    }
                  ]
                }
              ]
            }
          }
        ]
      }
    }
  ],
  "template_variables": [
    {
      "name": "budget",
      "default": "my-budget",
      "prefix": "budget_name"
    },
    {
      "name": "cluster",
      "default": "my-cluster",
      "prefix": "cluster_name"
    },
    {
      "name": "project",
      "default": "*",
      "prefix": "project"
    }
  ],
  "layout_type": "ordered",
  "is_read_only": true,
  "notify_list": [],
  "id": "5bg-q88-87d"
}
